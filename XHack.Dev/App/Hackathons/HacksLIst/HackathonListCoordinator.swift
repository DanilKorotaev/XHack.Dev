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
    
    var rootNavigationController: UINavigationController?
    
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
            .subscribe(onNext: { [weak self] hack in self?.toSelectHackFilters() })
            .disposed(by: disposeBag)
        
    }
    
    func didSelect(hack: ShortHackathon) {
        let coordinator = Container.resolve(HackathonDetailCoordinator.self)
        coordinator.navigationController = navigationController
        coordinator.hackId = hack.id
        start(coordinator: coordinator)
    }
        
    func toSelectHackFilters() {
        let coordinator = Container.resolve(SearchHackathonsCoordinator.self)
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
//        let coordinator = Container.resolve(HackFilterDialogCoordinator.self)
//        let navController = rootNavigationController ?? navigationController
//        coordinator.navigationController = navController
//        start(coordinator: coordinator)
//            .subscribe(onNext: { [weak self] result in
//                self?.toHackSearch(result)
//            })
//            .disposed(by: disposeBag)
    }
    
    
    func toHackSearch(_ params: HackFilterResult) {
        let filterParameter: SearchHackathonParameter?
        switch params {
        case .rejected:
            return
        case .success:
            filterParameter = nil
        case .skip:
            filterParameter = nil
        }
        
        let coordinator = Container.resolve(SearchHackathonsCoordinator.self)
        coordinator.navigationController = self.navigationController
        coordinator.filterParameters = filterParameter
        self.start(coordinator: coordinator)
    }
}
