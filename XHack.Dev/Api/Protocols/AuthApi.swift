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
    func singIn(creadential: SignInRequest) -> Observable<ApiResult<SignInResponse>>
    func signUp(_ model: SignUpRequest) -> Observable<ApiResult<SignUpResponse>>
}
