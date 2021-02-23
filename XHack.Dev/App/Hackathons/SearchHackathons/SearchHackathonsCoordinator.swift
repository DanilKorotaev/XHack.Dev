//
//  HackathonsListCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import Swinject


struct SearchHackathonParameter {
    
}


class SearchHackathonsCoordinator: BaseCoordinator<Void> {
    
    let viewModel: SearchHackathonsViewModel
    
    var filterParameters: SearchHackathonParameter?
    
    init(viewModel: SearchHackathonsViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        let viewController = SearchHackathonsViewController.instantiate()
        viewController.dataContext = viewModel
        navigationController.pushViewController(viewController, animated: true)
        setupBinding()
        return Observable.empty()
    }
    
    func setupBinding() {
        viewModel.didSelectHack.subscribe(onNext: { [weak self] hack in
            self?.didSelect(hack: hack)
        }).disposed(by: disposeBag)
        
        viewModel.back.subscribe(onNext: { [weak self] _ in
            self?.navigationController.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func didSelect(hack: ShortHackathon) {
        let coordinator = Container.resolve(HackathonDetailCoordinator.self)
        coordinator.navigationController = navigationController
        coordinator.viewModel.hackathonId = hack.id
        start(coordinator: coordinator)
    }
}
