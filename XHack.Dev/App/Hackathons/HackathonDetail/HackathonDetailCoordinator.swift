//
//  HackathonDetailCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import Swinject

class HackathonDetailCoordinator: BaseCoordinator<Void> {
    let hackathonApi: IHackathonsApi
    let viewModel: HackathonDetailViewModel
    var hackId: Int = 0
    
    init(viewModel: HackathonDetailViewModel, hackathonApi: IHackathonsApi) {
        self.hackathonApi = hackathonApi
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        let viewController = HackathonDetailViewController.instantiate()
        viewController.dataContext = viewModel
        viewModel.hackathonId = hackId
        applyBindings()
        navigationController.isNavigationBarHidden = false
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(viewController, animated: true)
        
        return Observable.empty()
    }
    
    
    private func applyBindings() {
        viewModel.back.subscribe(onNext: { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.memberSelected.subscribe(onNext: {  [weak self] member in
            self?.toMemberProfile(member)
        }).disposed(by: disposeBag)
        
        viewModel.teamSelected.subscribe(onNext: {  [weak self] team in
            self?.toTeamProfile(team)
        }).disposed(by: disposeBag)
        
        viewModel.memberSearch.subscribe(onNext: {  [weak self] _ in
            self?.toMemberSearch()
        }).disposed(by: disposeBag)
        
        viewModel.teamSearch.subscribe(onNext: {  [weak self] _ in
            self?.toTeamSearch()
        }).disposed(by: disposeBag)
        
        viewModel.createTeam.subscribe(onNext: {  [weak self] _ in
            self?.createTeam()
        }).disposed(by: disposeBag)
    }
    
    
    private func toMemberProfile(_ member: ShortUser) {
        let coordinator = Container.resolve(UserDetailsCoordinator.self)
        coordinator.navigationController = self.navigationController
        coordinator.userId = member.id
        self.start(coordinator: coordinator)
    }
    
    private func toTeamProfile(_ team: ShortTeam) {
        let coordinator = Container.resolve(HackTeamDetailsCoordinator.self)
        coordinator.navigationController = self.navigationController
        coordinator.teamId = team.id
        self.start(coordinator: coordinator)
    }
    
    private func toTeamSearch() {
        let coordinator = Container.resolve(HackTeamListCoordinator.self)
        coordinator.navigationController = self.navigationController
        coordinator.viewModel.hackId = viewModel.hackathonId
        self.start(coordinator: coordinator)
    }
    
    private func toMemberSearch() {
        let coordinator = Container.resolve(HackMemberListCoordinator.self)
        coordinator.navigationController = self.navigationController
        coordinator.viewModel.hackId = viewModel.hackathonId
        self.start(coordinator: coordinator)
    }
    
    private func createTeam() {
        let coordinator = Container.resolve(CreateTeamCoordinator.self)
        coordinator.navigationController = self.navigationController
        coordinator.parameter = .createForHack(id: hackId)
        self.start(coordinator: coordinator).subscribe(onNext: { [weak self] result in
            switch (result){
            case .teamCreated:
                self?.viewModel.forceContentRefreshingAsync()                
            default:
                break
            }
        }).disposed(by: disposeBag)
    }
}
