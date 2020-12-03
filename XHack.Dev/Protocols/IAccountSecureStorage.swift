//
//  IAccountSecureStorage.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

protocol IAccountSecureStorage {
    func getLogin() -> String
    func getTokens() -> Tokens
    @discardableResult
    func saveLogin(login: String) -> Bool
    @discardableResult
    func saveTokens(token: Tokens) -> Bool
    func clearStorage() 
}
