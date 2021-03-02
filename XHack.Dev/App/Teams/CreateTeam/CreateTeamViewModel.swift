//
//  CreateTeamViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 11.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class CreateTeamViewModel: BaseViewModel {
    private var teamsApi: ITeamsApi

    var hackId: Int?
    var teamName = BehaviorSubject(value: "")
    var teamDescription = BehaviorSubject(value: "")
    let canCreateTeam = BehaviorSubject<Bool>(value: false)
    let teamCreated = PublishSubject<Void>()
    let back = PublishSubject<Void>()
    
    init(teamsApi: ITeamsApi) {
        self.teamsApi = teamsApi
    }
    
    override func applyBinding () {
        Observable
            .combineLatest(teamName, teamDescription)
            .map { $0.hasNonEmptyValue() && $1.hasNonEmptyValue() }
            .bind(to: canCreateTeam)
            .disposed(by: disposeBag)
    }
    
    
    func createTeam() {
        isLoading.onNext(true)
        let model = CreateTeamDto(name: teamName.value, description: teamDescription.value, avatarUrl: nil)
        let method = hackId != nil ? teamsApi.create(for: hackId!, team: model) :
            teamsApi.create(team: model)
        
        method.done { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading.onNext(false)
            if self.checkAndProcessApiResult(response: result, "создать команду") {
                return
            }
            self.teamCreated.onNext(())
        }
    }
}
