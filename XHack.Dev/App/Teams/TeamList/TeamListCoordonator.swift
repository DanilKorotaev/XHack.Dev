//
//  TeamListCoordonator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 05.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class TeamListCoordonator: BaseCoordinator<Void> {
    let viewModel: TeamListViewModel

    
    init(viewModel: TeamListViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        let viewController = TeamListViewController.instantiate()
        navigationController.viewControllers = [viewController]
        viewController.dataContext = viewModel
        setUpBinding()
        return Observable.empty()
    }
    
    func setUpBinding() {
        viewModel.createTask
            .observeOn(MainScheduler.instance)
            .subscribe({ _ in
                self.toCteateTeam()
            })
            .disposed(by: disposeBag)
    }

    
    func toCteateTeam() {
        let coordinator = AppDelegate.container.resolve(CreateTeamCoordinator.self)!
        coordinator.navigationController = navigationController
        start(coordinator: coordinator).subscribe( { (result) in
            self.viewModel.refreshContent()
        }).disposed(by: disposeBag)
    }
}
