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
    func saveLogin(login: String) -> Bool
    func saveTokens(token: Tokens) -> Bool
    func clearStorage() 
}
