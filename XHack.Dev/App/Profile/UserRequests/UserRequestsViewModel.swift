//
//  UserRequestsViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 14.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class UserRequestsViewModel: BaseViewModel {
    
    let requestApi: IRequestsApi
    
    let close = PublishSubject<Void>()
    var apply = PublishSubject<TeamRequest>()
    var cancel = PublishSubject<TeamRequest>()
    var requests = BehaviorSubject<[TeamRequest]>(value: [])
    let requestChanged = PublishSubject<Void>()
    
    init(requestApi: IRequestsApi) {
        self.requestApi = requestApi
    }
    
    override func applyBinding() {
        apply.bind { (request) in
            self.apply(request: request)
        }.disposed(by: disposeBag)
        
        cancel.bind { (request) in
            self.cancel(request: request)
        }.disposed(by: disposeBag)
    }
    
    private func apply(request: TeamRequest) {
        requestApi.acceptRequestUserToTeam(requestId: request.id).done { (result) in
            self.checkAndProcessApiResult(response: result, "принять запрос")
        }
        requestChanged.onNext(())
    }
    
    private func cancel(request: TeamRequest) {
        if request.type == .teamToUser {
            requestApi.withdrawRequest(requestId: request.id).done { (result) in
                self.checkAndProcessApiResult(response: result, "отозвать запрос")
            }
        } else {
            requestApi.declineRequestUserToTeam(requestId: request.id).done { (result) in
                self.checkAndProcessApiResult(response: result, "отклонить запрос")
            }
        }
        requestChanged.onNext(())
    }
}
