//
//  HackathonDetailViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

class HackathonDetailViewModel: BaseViewModel {
    
    let hackathonsApi: IHackathonsApi
    let bookmarksApi: IBookmarksApi
    let messanger: IMessager
    var hackathonId: Int = 0
    
    let hackathon = BehaviorSubject<HackathonDetail?>(value: .none)
    let didWillGoChanged = PublishSubject<Bool>()
    let changeParticipantState = PublishSubject<Void>()
    let bookmark = PublishSubject<Void>()
    let back = PublishSubject<Void>()
    let memberSelected = PublishSubject<ShortUser>()
    let teamSelected = PublishSubject<ShortTeam>()
    let memberSearch = PublishSubject<Void>()
    let teamSearch = PublishSubject<Void>()
    let createTeam = PublishSubject<Void>()
    
    init(hackathonsApi: IHackathonsApi, bookmarksApi: IBookmarksApi, messanger: IMessager) {
        self.hackathonsApi = hackathonsApi
        self.bookmarksApi = bookmarksApi
        self.messanger = messanger
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        isLoading.onNext(true)
        hackathonsApi.getHackathonDetails(by: hackathonId)
            .done { [weak self] result in
                guard let self = self else { return }
                self.isLoading.onNext(false)
                if self.checkAndProcessApiResult(response: result, "загрузить детальную информацию") {
                    return
                }
                guard let content = result.content else { self.showMessage(title: "Ошибка", message: "Не удалось загрузить детальную информацию"); return}
                self.hackathon.onNext(HackathonDetail(content))
            }
    }
    
    override func applyBinding() {
        didWillGoChanged.subscribe(onNext: { userWillGo in
            let changedStatus = userWillGo ? self.hackathonsApi.willGoHackathon(id: self.hackathonId) : self.hackathonsApi.willNotGoHackathon(id: self.hackathonId)
            changedStatus.done { (result) in
                if self.checkAndProcessApiResult(response: result, "") {
                    return
                }
            }
        }).disposed(by: disposeBag)
        
        changeParticipantState.subscribe(onNext: { [weak self] in
            self?.changeParticipantStateExecute()
        }).disposed(by: disposeBag)
        
        bookmark.subscribe(onNext: { [weak self] in
            self?.bookmarkHack()
        }).disposed(by: disposeBag)
    }
    
    
    private func changeParticipantStateExecute() {
        guard let hack = hackathon.value else { return }
        switch(hack.participationType) {
        case .teamMember:
            leaveFromTeam()
        case .none:
            joinToHack()
        case .single:
            cancelSingleParticitation()
        case .teamCaptain:
            cancelTeamParticitation()
        }
    }
    
    private func cancelSingleParticitation() {
        hackathonsApi.willNotGoHackathon(id: hackathonId).done { [weak self] (result) in
            guard let self = self else { return }
            if self.checkAndProcessApiResult(response: result, "отменить участие в хакатоне") {
                return
            }
            self.forceContentRefreshingAsync()
        }
    }
    
    private func cancelTeamParticitation() {
        hackathonsApi.unsingTeamFromHack(hackId: hackathonId).done { [weak self] (result) in
            guard let self = self else { return }
            if self.checkAndProcessApiResult(response: result, "отменить участие в хакатоне") {
                return
            }
            self.forceContentRefreshingAsync()
        }
    }
    
    private func leaveFromTeam() {
        hackathonsApi.leaveTeam(for: hackathonId).done { [weak self] (result) in
            guard let self = self else { return }
            if self.checkAndProcessApiResult(response: result, "выйти из команды") {
                return
            }
            self.forceContentRefreshingAsync()
        }
    }
    
    private func joinToHack() {
        let likeTeam = DialogActionInfo(title: "Как команда") { [weak self] in
            self?.createTeam.onNext(())
        }
        
        let likeMember = DialogActionInfo(title: "Как участник") { [weak self] in
            guard let self = self else { return }
            self.hackathonsApi.willGoHackathon(id: self.hackathonId)
                .done { (result) in
                    if self.checkAndProcessApiResult(response: result, "пойти на хакатон") {
                        return
                    }
                    self.forceContentRefreshingAsync()
                }
        }
        
        let cancel = DialogActionInfo(title: "Отменить", isAccented: false)
        
        let message = AlertDialogMessage(title: "", message: "Как хотите участвовать?", dialogActions: [likeTeam, likeMember, cancel], style: .actionSheet)
        
        messanger.publish(message: message)
    }
    
    private func bookmarkHack() {
        guard let hack = self.hackathon.value else { return }
        let dto = BookmarkHackathonDTO(hackathonId: hackathonId)
        let method = hack.isBookmarked.value ?             bookmarksApi.removeBookmark(hackathon: dto) :
            bookmarksApi.bookmark(hackathon: dto)
            
        method.done { [weak self] (result) in
            guard let self = self, let hack = self.hackathon.value else { return }
            let message = hack.isBookmarked.value ? "удалить из закладок" : "добавить в закладки"
            if self.checkAndProcessApiResult(response: result, message) {
                return
            }
            hack.isBookmarked.invert()
        }
    }
}
