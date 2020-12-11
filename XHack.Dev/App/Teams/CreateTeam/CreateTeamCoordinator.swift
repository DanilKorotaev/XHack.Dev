//
//  CreateTeamCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 11.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

enum CreateTeamCoordinatorResult {
    case rejected
    case teamCreated
}

class CreateTeamCoordinator : BaseCoordinator<CreateTeamCoordinatorResult> {
    private let viewModel: CreateTeamViewModel
    private let result = PublishSubject<CreateTeamCoordinatorResult>()
    
    init(viewModel: CreateTeamViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<CreateTeamCoordinatorResult> {
        let viewController = CreateTeamViewController.instantiate()
        viewController.viewModel = viewModel
        
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(viewController, animated: true)
        setUpBinding()
        return result
    }
    
    
    func setUpBinding() {
        viewModel.taskCreated
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.navigationController.popViewController(animated: true)
                self?.result.onNext(.teamCreated)
            })
            .disposed(by: disposeBag)
    }
}
