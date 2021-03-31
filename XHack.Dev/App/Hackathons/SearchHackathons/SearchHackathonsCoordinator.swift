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
        viewModel.didSelectHack.bind { [weak self] hack in
            self?.didSelect(hack: hack)
        }.disposed(by: disposeBag)
        
        viewModel.selectFilters.bind { [weak self] hack in
            self?.setFilters()
        }.disposed(by: disposeBag)
        
        viewModel.back.subscribe(onNext: { [weak self] _ in
            self?.navigationController.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func didSelect(hack: ShortHackathon) {
        let coordinator = Container.resolve(HackathonDetailCoordinator.self)
        coordinator.navigationController = navigationController
        coordinator.hackId = hack.id
        start(coordinator: coordinator)
    }
    
    func setFilters() {
        let coordinator = Container.resolve(HackFiltersCoordinator.self)
        coordinator.navigationController = navigationController
        coordinator.parameter = HackFiltersParameter(filters: viewModel.filters)
        start(coordinator: coordinator).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch (result) {
            case .rejected:
                return
            case .successfull(filters: let filters):
                self.viewModel.filtersSelected.onNext(filters)
            }
        }).disposed(by: disposeBag)
    }
}
