//
//  UserDetailsViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 02.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class UserDetailsViewModel: BaseViewModel {
    let usersApi: IUserApi
    let bookmarksApi: IBookmarksApi
    let context: IAppContext
    let requestsApi: IRequestsApi
    let teamId: Int? = .none
    
    let back = PublishSubject<Void>()
    let bookmark = PublishSubject<Void>()
    let changeRelatonState = PublishSubject<Void>()
    let showRequests = PublishSubject<[TeamRequest]>()
    
    let user = BehaviorSubject<UserDetails?>(value: nil)
    let isCurrentUser = BehaviorSubject<Bool>(value: true)
    var userId: Int = 0
    
    init(bookmarksApi: IBookmarksApi, usersApi: IUserApi, context: IAppContext, requestsApi: IRequestsApi) {
        self.usersApi = usersApi
        self.bookmarksApi = bookmarksApi
        self.context = context
        self.requestsApi = requestsApi
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        isLoading.onNext(true)
        usersApi.getProfile(id: userId).done { [weak self] (result) in
            guard let self = self else { return }
            if self.checkAndProcessApiResult(response: result, "загрузить детальную информацию участника") {
                return
            }
            guard let user = result.content else {
                self.showMessage(title: "Ошибка", message: "Не удалось загрузить детальную информацию участника")
                return
            }
            self.user.onNext(UserDetails(user))
            if let currentUserId = self.context.currentUser?.id {
                self.isCurrentUser.onNext(currentUserId == user.id)
            }
        }
    }
    
    
    override func applyBinding() {
        bookmark.subscribe(onNext: { [weak self] in
            self?.bookmarkUser()
        }).disposed(by: disposeBag)
        
        changeRelatonState.subscribe(onNext: { [weak self] in
            self?.changeRelationStateExecute()
        }).disposed(by: disposeBag)
    }
    
    private func bookmarkUser() {
        guard let user = self.user.value else { return }
        let dto = BookmarkUserDTO(userId: userId)
        
        let method = user.isBookmarked.value ?
            bookmarksApi.removeBookmark(user: dto) :
            bookmarksApi.bookmark(user: dto)
            
        method.done { [weak self] (result) in
            guard let self = self, let user = self.user.value else { return }
            let message = user.isBookmarked.value ? "удалить из закладок" : "добавить в закладки"
            if self.checkAndProcessApiResult(response: result, message) {
                return
            }
            user.isBookmarked.invert()
        }
    }
    
    private func changeRelationStateExecute() {
        guard let requests = user.value?.requests else { return }
        if requests.isEmpty {
            sendRequest()
        } else {
            showRequests.onNext(requests)
        }
//        else if requests.contains(where: { $0.type == .teamToUser}) {
//            withdrawRequest()
//        } else if requests.contains(where: { $0.type == .userToTeam}) {
//            applyRequest()
//        }
    }
    
    
    private func sendRequest() {
        self.selectTeam().done { (selectResult) in
            switch selectResult {
            case .rejected:
                return
            case .noTeams:
                self.showMessage(title: "", message: "У вас нет команд. Создайте команду, чтобы отправить запрос")
                return
            case .successful(let team):
                self.requestsApi.sendRequest(to: CreateRequestToUserDto(userId: self.userId, teamId: team.id)).done { (result) in
                    if self.checkAndProcessApiResult(response: result, "отправить запрос") {
                        return
                    }
                    self.forceContentRefreshingAsync()
                }
            }
        }
    }
    
    private func withdrawRequest() {
        requestsApi.withDrawRequestToUser(userId: userId).done { (result) in
            if self.checkAndProcessApiResult(response: result, "отозвать запрос") {
                return
            }
            self.forceContentRefreshingAsync()
        }
    }
    
    private func applyRequest() {
        
    }
}
