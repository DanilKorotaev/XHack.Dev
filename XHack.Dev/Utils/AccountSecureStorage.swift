//
//  AccountSecureStorage.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

class AccountSecureStorage: IAccountSecureStorage {
    
    private enum SecurityKey: String {
        case login
        case accessToken
        case refreshToken
        case userName
        case userSurname
    }
    
    func getLogin() -> String {
        KeyChainHelper.shared.getValue(for: SecurityKey.login.rawValue)
    }
    
    func getTokens() -> Tokens {
        let accessToken = KeyChainHelper.shared.getValue(for: SecurityKey.accessToken.rawValue)
        let refreshToken = KeyChainHelper.shared.getValue(for: SecurityKey.refreshToken.rawValue)
        return Tokens(accessToken: accessToken, refreshToken:  refreshToken)
    }
    
    @discardableResult
    func saveLogin(login: String) -> Bool {
        KeyChainHelper.shared.set(value: login, for: SecurityKey.login.rawValue)
    }
    
    @discardableResult
    func saveTokens(token: Tokens) -> Bool {
        KeyChainHelper.shared.set(value: token.accessToken, for: SecurityKey.accessToken.rawValue)
        && KeyChainHelper.shared.set(value: token.refreshToken ?? "", for: SecurityKey.refreshToken.rawValue)
    }
    
    func clearStorage() {
        KeyChainHelper.shared.removeKey(SecurityKey.accessToken.rawValue)
        KeyChainHelper.shared.removeKey(SecurityKey.refreshToken.rawValue)
        KeyChainHelper.shared.removeKey(SecurityKey.login.rawValue)
    }
}
