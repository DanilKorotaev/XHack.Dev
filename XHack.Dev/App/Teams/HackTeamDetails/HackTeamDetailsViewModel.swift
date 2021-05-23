//
//  HackTeamDetailsViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 24.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class HackTeamDetailsViewModel: BaseViewModel {
    let teamsApi: ITeamsApi
    let bookmarksApi: IBookmarksApi
    let requestsApi: IRequestsApi
    let messager: IMessager
    let context: IAppContext
    
    let team = BehaviorSubject<TeamDetails?>(value: .none)
    let back = PublishSubject<Void>()
    let bookmark = PublishSubject<Void>()
    let memberSelected = PublishSubject<ShortUser>()
    let memberActionRequested = PublishSubject<ShortUser>()
    let teamRemoved = PublishSubject<Void>()
    let changeParticipantState = PublishSubject<Void>()
    let chat = PublishSubject<Void>()
    let edit = PublishSubject<Void>()
    let canBookmark = BehaviorSubject<Bool>(value: false)
    let canChat = BehaviorSubject<Bool>(value: false)
    let canEdit = BehaviorSubject<Bool>(value: false)
    let showRequests = PublishSubject<[TeamRequest]>()
    var teamId: Int = 0
        
    init(teamsApi: ITeamsApi, bookmarksApi: IBookmarksApi, requestsApi: IRequestsApi, messager: IMessager, context: IAppContext) {
        self.teamsApi = teamsApi
        self.bookmarksApi = bookmarksApi
        self.requestsApi = requestsApi
        self.messager = messager
        self.context = context
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        isLoading.onNext(true)
        
        teamsApi.getDetail(for: teamId).done { [weak self] (result) in
            guard let self = self else { return }
            if self.checkAndProcessApiResult(response: result, "загрузить детальную информацию команды") {
                return
            }
            guard let teamDto = result.content else {
                self.showMessage(title: "Ошибка", message: "Не удалось загрузить детальную информацию команды")
                return
            }
            let team = TeamDetails(data: teamDto)
            let isMember = team.participantType.isMember
            self.canChat.onNext(isMember)
            self.canBookmark.onNext(!isMember)
            self.canEdit.onNext(team.participantType == .captaint)
            self.team.onNext(team)
        }
    }
    
    override func applyBinding() {
        bookmark.subscribe(onNext: { [weak self] in
            self?.bookmarkTeam()
        }).disposed(by: disposeBag)
        
        changeParticipantState.subscribe(onNext: { [weak self] in
            self?.changeParticipantStateExecute()
        }).disposed(by: disposeBag)
        
        memberActionRequested.bind { [weak self] member in
            self?.memberActionExecute(member)
        }.disposed(by: disposeBag)
    }
    
    private func bookmarkTeam() {
        guard let team = self.team.value else { return }
        let dto =  BookmarkTeamDTO(teamId: teamId)
        let method = team.isBookmarked.value ?
            bookmarksApi.removeBookmark(team: dto) :
            bookmarksApi.bookmark(team: dto)
            
        method.done { [weak self] (result) in
            guard let self = self, let team = self.team.value else { return }
            let message = team.isBookmarked.value ? "удалить из закладок" : "добавить в закладки"
            if self.checkAndProcessApiResult(response: result, message) {
                return
            }
            team.isBookmarked.invert()
        }
    }
    
    private func changeParticipantStateExecute() {
        guard let team = self.team.value else { return }
        switch (team.participantType){
        case .none:
            sendRequestExecute()
        case .member:
            leaveFromTeamExecute()
        case .outgoingRequest:
            fallthrough
        case .incomingRequest:
            showRequests.onNext(team.requests)
        case .captaint:
            removedTeamExecute()
        default:
            // do nothing
            break
        }
    }
    
    private func removedTeamExecute() {
        let removeTeam: () -> Void = {
            self.teamsApi.removeTeam(teamId: self.teamId).done { (result) in
                if self.checkAndProcessApiResult(response: result, "удалить команду") {
                    return
                }
                self.teamRemoved.onNext(())
            }
        }
        let message = AlertDialogMessage(title: "Внимание", message: "При удалении команды, чат команды удалиться. Вы действительно хотите удалить команду?", dialogActions: [DialogActionInfo.cancel, DialogActionInfo(title: "Удалить", action: removeTeam)])
        messager.publish(message: message)
       
    }
    
    private func leaveFromTeamExecute() {
        teamsApi.leave(teamId: teamId).done { [weak self] (result) in
            guard let self = self else { return }
            if self.checkAndProcessApiResult(response: result, "покинуть команду") {
                return
            }
            self.forceContentRefreshingAsync()
        }
    }
    
    private func withdrawRequestExecute() {
        requestsApi.withDrawRequestToTeam(teamId: teamId).done { [weak self] (result) in
            guard let self = self else { return }
            if self.checkAndProcessApiResult(response: result, "отозвать запрос") {
                return
            }
            self.forceContentRefreshingAsync()
        }
    }
    
    private func acceptRequestExecute() {
        requestsApi.acceptRequestFromTeam(teamId: teamId).done { [weak self] (result) in
            guard let self = self else { return }
            if self.checkAndProcessApiResult(response: result, "принять запрос") {
                return
            }
            self.forceContentRefreshingAsync()
        }
    }
    
    private func sendRequestExecute() {
        requestsApi.sendRequest(to: CreateRequestToTeamDto(teamId: teamId)).done { [weak self] (result) in
            guard let self = self else { return }
            if self.checkAndProcessApiResult(response: result, "отправить запрос") {
                return
            }
            self.forceContentRefreshingAsync()
        }
    }
    
    private func memberActionExecute(_ member: ShortUser) {
        if member.id == context.currentUser?.id {
            return
        }
        
        let delete: () -> Void = {
            self.teamsApi.removeTeammate(teamId: self.teamId, userId: member.id).done { (result) in
                if self.checkAndProcessApiResult(response: result, "исключить \(member.name) из команды") {
                    return
                }
                self.forceContentRefreshingAsync()
            }
        }
        
        let message = AlertDialogMessage(title: nil, message: nil, dialogActions: [
            DialogActionInfo(title: "Исключить из команды", action: delete),
            DialogActionInfo.cancel
        ], style: .actionSheet)
        
        messager.publish(message: message)
    }
}
