//
//  SentRequestCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 27.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class SentRequestCoordinator: BaseCoordinator<Void> {
    
    private let viewModel: SentRequestViewModel
    
    init(viewModel: SentRequestViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        let viewController = SentRequestViewController.instantiate()
        viewController.dataContext = viewModel
        applyBindings()
        navigationController.pushViewController(viewController, animated: true)
        
        return Observable.empty()
    }
    
    private func applyBindings() {
        viewModel.back.bind { _ in
            self.navigationController.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        viewModel.requestSelected.bind { [weak self] (request) in
            guard let self = self else { return}
            switch (request.type) {
            case .teamToUser:
                self.toUserDetails(for: request.user.id)
            case .userToTeam:
                self.toTeamProfile(for: request.team.id)
            default:
                break
            }
        }.disposed(by: disposeBag)
    }
}
