//
//  UserDetailsCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 02.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import Swinject

class UserDetailsCoordinator: BaseCoordinator<Void> {
    
    let viewModel: UserDetailsViewModel
    var userId: Int = 0
    
    init(viewModel: UserDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        let viewController = UserDetailsViewController.instantiate()
        viewController.dataContext = viewModel
        viewModel.userId = userId
        navigationController.pushViewController(viewController, animated: true)
        applyBindings()
        return Observable.empty()
    }
    
    func applyBindings() {
        viewModel.back.subscribe(onNext: { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.showRequests.subscribe(onNext: { [weak self] requests in
            self?.showRequests(requests)
        }).disposed(by: disposeBag)
    }
    
    private func showRequests(_ requests: [TeamRequest]) {
        let coordinator = Container.resolve(UserRequestsCoordinator.self)
        coordinator.navigationController = navigationController
        coordinator.requests = requests
        coordinator.start().subscribe(onNext: { _ in
            self.viewModel.forceContentRefreshingAsync()
        }).disposed(by: disposeBag)
    }
}
