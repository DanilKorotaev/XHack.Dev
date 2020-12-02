//
//  ApiTokensHolder.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class ApiTokensHolder: IApiTokensHolder {
    
    private let accountSecureStorage: IAccountSecureStorage
    private let endpoints: ApiEndpoints
    
    private(set) var login: String = ""
    var accessToken: String { tokens.accessToken }
    var refreshToken: String { tokens.refreshToken ?? "" }
    private var tokens: Tokens
    
    init(accountSecureStorage: IAccountSecureStorage, endpoints: ApiEndpoints) {
        self.accountSecureStorage = accountSecureStorage
        self.endpoints = endpoints
        tokens = Tokens(accessToken: "")
    }
    
    func updateToken(login: String, password: String) -> Single<LiteApiResult> {
        //TODO
        return Single.create { (single) -> Disposable in
            Disposables.create()
        }
    }
    
    func updateToken() -> Single<LiteApiResult> {
        //TODO
        return Single.create { (single) -> Disposable in
            Disposables.create()
        }
    }
    
    func restoreTokensFromCashe() -> Single<Bool> {
        login =  accountSecureStorage.getLogin()
        tokens = accountSecureStorage.getTokens()
        return Single.create { (single) -> Disposable in
            Disposables.create()
        }
    }
    
    func clearToken() {
        login = ""
        accountSecureStorage.clearStorage()
    }
    
    
}
