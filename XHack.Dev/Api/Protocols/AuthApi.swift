//
//  AuthApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthApi {
    func singIn(creadential: SignInRequest) -> Single<ApiResult<SignInResponse>>
    func signUp(_ model: SignUpRequest) -> Single<ApiResult<SignUpResponse>>
}
