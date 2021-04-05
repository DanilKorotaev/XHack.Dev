//
//  AuthApiExecuter.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

class AuthApiExecuter: AuthApi {
    private let endpointsProvider: ApiEndpoints
    private let apiTokenHolder: IApiTokensHolder
    
    init(endpointsProvider: ApiEndpoints, apiTokenHolder: IApiTokensHolder) {
        self.endpointsProvider = endpointsProvider
        self.apiTokenHolder = apiTokenHolder
    }
    
    func singIn(creadential: SignInRequest) -> Promise<ApiResult<SignInResponse>> {
        let url = endpointsProvider.gatewayUrl + "/api/auth/login"
        return ApiHelpers.executeReliablyPostRequest(apiTokenHolder: apiTokenHolder, url: url, content: creadential)
    }
    
    func signUp(_ model: SignUpRequest) -> Promise<ApiResult<SignUpResponse>>{
        let url = endpointsProvider.gatewayUrl + "/api/auth/register"
        return ApiHelpers.executeReliablyPostRequest(apiTokenHolder: apiTokenHolder, url: url, content: model)
    }
    
    func checkUserExist() -> Promise<ApiResult<Bool>> {
        let url = endpointsProvider.gatewayUrl + "/api/users/checkUserExists"
        return ApiHelpers.executeReliablyGetRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
}
