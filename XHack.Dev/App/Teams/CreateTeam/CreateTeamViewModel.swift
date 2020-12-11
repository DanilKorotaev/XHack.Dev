//
//  CreateTeamViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 11.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class CreateTeamViewModel {
    private var teamsApi: ITeamsApi
    private let disposeBag = DisposeBag()

    let isLoading = BehaviorSubject(value: true)
    var teamName = BehaviorSubject(value: "")
    var teamDescription = BehaviorSubject(value: "")
    let canCreateTeam = BehaviorSubject<Bool>(value: false)
    let taskCreated = PublishSubject<Void>()
    
    init(teamsApi: ITeamsApi) {
        self.teamsApi = teamsApi
        setupBinding()
    }
    
    func setupBinding() {
        Observable
            .combineLatest(teamName, teamDescription)
            .map { $0.hasNonEmptyValue() && $1.hasNonEmptyValue() }
            .bind(to: canCreateTeam)
            .disposed(by: disposeBag)
    }
    
    
    func createTeam() {
        isLoading.onNext(true)
        
        Observable
            .combineLatest(teamName, teamDescription, canCreateTeam)
            .take(1)
            .filter { _, _, active in active }
            .map { teamName, teamDescription, _ in CreateTeamDto(name: teamName, description: teamDescription)  }
            .flatMapLatest { [weak self] in self!.teamsApi.create(team: $0) }
            .subscribe { [weak self] _ in
                self?.isLoading.onNext(false)
                self?.taskCreated.onNext(())
            }
            .disposed(by: disposeBag)
    }
    
}
