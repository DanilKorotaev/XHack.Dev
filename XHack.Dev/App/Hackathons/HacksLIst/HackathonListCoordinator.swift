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

class HackathonListCoordinator: BaseCoordinator<Void> {
    
    let viewModel: HackathonListViewModel
    
    init(viewModel: HackathonListViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        let viewController = HackathonListViewController.instantiate()
        viewController.dataContext = viewModel
        navigationController.pushViewController(viewController, animated: true)
        navigationController.tabBarItem = UITabBarItem(title: "hacks", image: #imageLiteral(resourceName: "Calendar"), selectedImage: #imageLiteral(resourceName: "Calendar_tap").withRenderingMode(.alwaysOriginal))       
        setupBinding()
        return Observable.empty()
    }
    
    func setupBinding() {
        viewModel.didSelectHack
            .subscribe(onNext: { [weak self] hack in self?.didSelect(hack: hack) })
            .disposed(by: disposeBag)
        
        viewModel.seachRequsted
            .subscribe(onNext: { [weak self] hack in self?.toHackSearch() })
            .disposed(by: disposeBag)
        
    }
    
    func didSelect(hack: ShortHackathon) {
        let coordinator = Container.resolve(HackathonDetailCoordinator.self)
        coordinator.navigationController = navigationController
        coordinator.viewModel.hackathonId = hack.id
        start(coordinator: coordinator)
    }
    
    
    func toHackSearch() {
        let coordinator = Container.resolve(SearchHackathonsCoordinator.self)
        coordinator.navigationController = navigationController
        start(coordinator: coordinator)
    }
}
