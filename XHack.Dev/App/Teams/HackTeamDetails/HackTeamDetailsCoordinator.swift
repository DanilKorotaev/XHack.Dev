//
//  HackTeamDetailsCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 24.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import Swinject

class HackTeamDetailsCoordinator: BaseCoordinator<Void> {
    let viewModel: HackTeamDetailsViewModel
    var teamId: Int = 0
    
    init(viewModel: HackTeamDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        let viewController = HackTeamDetailsViewController.instantiate()
        viewController.dataContext = viewModel
        viewModel.teamId = teamId
        applyBindings()
        navigationController.pushViewController(viewController, animated: true)
        return Observable.empty()
    }
    
    private func applyBindings() {
        viewModel.back.subscribe(onNext: { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.memberSelected.bind { [weak self] member in
            self?.toUserProfile(member.id)
        }.disposed(by: disposeBag)
    }
    
    
    func toUserProfile(_ id: Int) {
        let coordinator = Container.resolve(UserDetailsCoordinator.self)
        coordinator.navigationController = self.navigationController
        coordinator.userId = id
        self.start(coordinator: coordinator)
    }
}
