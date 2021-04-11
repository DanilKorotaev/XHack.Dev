//
//  SentRequestViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 27.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class SentRequestViewModel: BaseViewModel {
    
    let back = PublishSubject<Void>()
    let requestApi: IRequestsApi
    
    let requestSelected = PublishSubject<ParticipantRequestable>()
    var requestSections =  ObservableArray<RequestSection>([])
    
    let refresh = PublishSubject<Void>()
    let isRefreshing = BehaviorSubject<Bool>(value: false)
    
    init(requestApi: IRequestsApi) {
        self.requestApi = requestApi
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        guard !isRefreshing.value, !isLoading.value else { return }
        if operationArgs.isManuallyTriggered {
            isRefreshing.onNext(true)
        } else {
            isLoading.onNext(true)
        }
    
        
        requestApi.getSentRequests().done { [weak self] (result) in
            guard let self = self else { return }
            self.isRefreshing.onNext(false)
            self.isLoading.onNext(false)
            if self.checkAndProcessApiResult(response: result, "загрузить список отправленных запросов") {
                return
            }
            guard let requests = result.content else {
                self.showMessage(title: "Ошибка", message: "Не удалось загрузить список входящих запросов")
                return
            }
            if operationArgs.isManuallyTriggered {
                self.requestSections.removeAll()
            }
            let fromTeam = RequestSection("Запросы командам", requests.toTeams.map { SentRequest($0) }.filter { $0.type != .none})
            let fromUsers = RequestSection("Запросы пользователям", requests.toUsers.map { SentRequest($0) }.filter { $0.type != .none})
            var requestSections: [RequestSection] = []
            if (!fromTeam.items.isEmpty) {
                requestSections.append(fromTeam)
            }
            if (!fromUsers.items.isEmpty) {
                requestSections.append(fromUsers)
            }
            self.requestSections.append(contentsOf: requestSections)
        }
    }
    
    override func applyBinding() {
        refresh.bind { [weak self] _ in
            self?.forceContentRefreshingAsync(operationArgs: OperationStateControl.ManuallyTriggered)
        }.disposed(by: disposeBag)
    }
}
