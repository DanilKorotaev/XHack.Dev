//
//  TeamListCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 23.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import Swinject

class HackTeamListCoordinator: BaseCoordinator<Void> {
    let viewModel: HackTeamListViewModel
    
    init(viewModel: HackTeamListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func start() -> Observable<Void> {
        let viewController = HackTeamListViewController.instantiate()
        viewController.dataContext = viewModel
        navigationController.pushViewController(viewController, animated: true)
        applyBindings()
        
        return Observable.empty()
    }
    
    private func applyBindings() {
        viewModel.back.subscribe(onNext: { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.teamSelected.subscribe(onNext: {  [weak self] team in
            self?.toTeamProfile(team)
        }).disposed(by: disposeBag)
    }
    
    private func toTeamProfile(_ team: Team) {
        let coordinator = Container.resolve(HackTeamDetailsCoordinator.self)
        coordinator.navigationController = self.navigationController
        coordinator.teamId = team.id
        self.start(coordinator: coordinator)
    }
}
