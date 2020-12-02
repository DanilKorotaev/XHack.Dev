//
//  IApiTokensHolder.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

protocol IApiTokensHolder {
    var login: String { get }
    var accessToken: String { get }
    var refreshToken: String { get}
    func updateToken(login: String, password: String) -> Single<LiteApiResult>
    func updateToken() -> Single<LiteApiResult>
    func restoreTokensFromCashe() -> Single<Bool>
    func clearToken()    
}
