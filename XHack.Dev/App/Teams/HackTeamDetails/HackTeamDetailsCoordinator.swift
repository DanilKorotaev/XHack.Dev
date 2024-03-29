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
        
        viewModel.teamRemoved.subscribe(onNext: { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.memberSelected.bind { [weak self] member in
            self?.toUserProfile(member.id)
        }.disposed(by: disposeBag)
        
        viewModel.chat.subscribe(onNext: { [weak self] _ in
            self?.toChat(for: self!.viewModel.team.value!)
        }).disposed(by: disposeBag)
        
        viewModel.showRequests.subscribe(onNext: { [weak self] requests in
            self?.showRequests(requests)
        }).disposed(by: disposeBag)
        
        viewModel.edit.subscribe(onNext: { [weak self] _ in
            self?.navigateToEditTeam()
        }).disposed(by: disposeBag)
    }
    
    
    func toUserProfile(_ id: Int) {
        let coordinator = Container.resolve(UserDetailsCoordinator.self)
        coordinator.navigationController = self.navigationController
        coordinator.userId = id
        self.start(coordinator: coordinator)
    }
    
    func toChat(for team: TeamDetails) {
        let coordinator = Container.resolve(ChatCoordinator.self)
        coordinator.navigationController = Container.resolve(MainScreeenProvider.self).navigationController
        coordinator.shortChat = ShortChat(id: team.chatId, team: ShortTeam(id: team.id, name: team.name, avatarUrl: team.avatarUrl))
        coordinator.start().subscribe(onNext: { result in
            if result == .chatCreated {
                self.viewModel.forceContentRefreshingAsync()
            }
        }).disposed(by: disposeBag)
    }
    
    func navigateToEditTeam() {
        let coordinator = Container.resolve(CreateTeamCoordinator.self)
        coordinator.navigationController = self.navigationController
        coordinator.parameter = .edit(profile: self.viewModel.team.value)
        self.start(coordinator: coordinator).subscribe(onNext: { [weak self] result in
            switch (result){
            case .teamEdited:
                self?.viewModel.forceContentRefreshingAsync()
            default:
                break
            }
        }).disposed(by: disposeBag)
    }
    
    private func showRequests(_ requests: [TeamRequest]) {
        let coordinator = Container.resolve(TeamRequestCoordinator.self)
        coordinator.navigationController = navigationController
        coordinator.requests = requests
        coordinator.start().subscribe(onNext: { _ in
            self.viewModel.forceContentRefreshingAsync()
        }).disposed(by: disposeBag)
    }
}
