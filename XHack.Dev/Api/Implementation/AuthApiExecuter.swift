//
//  AuthApiExecuter.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class AuthApiExecuter: AuthApi {
    private let endpointsProvider: ApiEndpoints
    private let httpClient: HttpClient
    private let apiTokenHolder: IApiTokensHolder
    
    init(endpointsProvider: ApiEndpoints, httpClient: HttpClient, apiTokenHolder: IApiTokensHolder) {
        self.endpointsProvider = endpointsProvider
        self.httpClient = httpClient
        self.apiTokenHolder = apiTokenHolder
    }
    
    func singIn(creadential: SignInRequest) -> Observable<ApiResult<SignInResponse>> {
        let url = endpointsProvider.gatewayUrl + "/api/auth/login"
        return ApiHelpers.executeReliablyPostRequest(apiTokenHolder: apiTokenHolder, url: url, content: creadential)
    }
    
    func signUp(_ model: SignUpRequest) -> Observable<ApiResult<SignUpResponse>>{
        let url = endpointsProvider.gatewayUrl + "/api/auth/register"
        return ApiHelpers.executeReliablyPostRequest(apiTokenHolder: apiTokenHolder, url: url, content: model)
    }
}
