//
//  CreateTeamViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 11.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

class CreateTeamViewModel: BaseViewModel {
    private var teamsApi: ITeamsApi

    private var hackId: Int?
    private var editTeamId: Int?
    
    var teamName = BehaviorSubject(value: "")
    var teamDescription = BehaviorSubject(value: "")
    let canCreateTeam = BehaviorSubject<Bool>(value: false)
    let teamCreated = PublishSubject<Void>()
    let teamEdited = PublishSubject<Void>()
    let back = PublishSubject<Void>()
    let chooseAvatar = PublishSubject<Void>()
    let avatarUrl = BehaviorSubject<String>(value: "")
    let avatarSelected = PublishSubject<File>()
    private(set) var mode: Mode!
    
    var parameter: CreateTeamParameter?
    
    init(teamsApi: ITeamsApi) {
        self.teamsApi = teamsApi
    }
    
    override func initialize() {
        if let profile = parameter?.profile {
            teamName.onNext(profile.name)
            teamDescription.onNext(profile.description)
            avatarUrl.onNext(profile.avatarUrl)
            mode = .edit
            editTeamId = profile.id
        } else {
            mode = .create
        }
        hackId = parameter?.hackId
        super.initialize()
    }
    
    override func applyBinding () {
        
        avatarSelected.bind { [weak self] file in
            self?.uploadAvatar(file: file)
        }.disposed(by: disposeBag)
        
        Observable
            .combineLatest(teamName, teamDescription)
            .map { $0.hasNonEmptyValue() && $1.hasNonEmptyValue() }
            .bind(to: canCreateTeam)
            .disposed(by: disposeBag)
    }
    
    
    private func uploadAvatar(file: File) {
        self.uploadFile(file).done { [weak self] (url) in
            guard let url = url else { return }
            self?.avatarUrl.onNext(url)
        }
    }
    
    func createTeam() {
        isLoading.onNext(true)
       
        let method: Promise<LiteApiResult>
        if mode == .edit, let editTeamId = editTeamId {
            method = teamsApi.update(team: UpdateTeamDto(name: teamName.value, description: teamDescription.value, avatarUrl: self.avatarUrl.value), for: editTeamId)
        } else {
            let model = CreateTeamDto(name: teamName.value, description: teamDescription.value, avatarUrl: self.avatarUrl.value)
            method = hackId != nil ? teamsApi.create(for: hackId!, team: model) :
             teamsApi.create(team: model)
        }
           
        
        method.done { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading.onNext(false)
            if self.checkAndProcessApiResult(response: result, "создать команду") {
                return
            }
            if self.mode == .edit {
                self.teamEdited.onNext(())
            } else {
                self.teamCreated.onNext(())
            }
        }
    }
    
    
    enum Mode {
        case create
        case edit
    }
}
