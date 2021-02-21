//
//  UserApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 03.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

class UserApi: IUserApi {
    
    private let endpointsProvider: ApiEndpoints
    private let apiTokenHolder: IApiTokensHolder
    
    init(endpointsProvider: ApiEndpoints,apiTokenHolder: IApiTokensHolder) {
        self.endpointsProvider = endpointsProvider
        self.apiTokenHolder = apiTokenHolder
    }
    
    func getProfile() -> Promise<ApiResult<UserProfileDto>> {
        let url = endpointsProvider.gatewayUrl + "/api/users/profile"
        return ApiHelpers.executeReliablyGetRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
    
    
    func updateProfile(_ data: UpdateProfileDtoRequest) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/users/profile"
        return ApiHelpers.executeReliablyLitePatchRequest(apiTokenHolder: apiTokenHolder, url: url, content: data)
    }
}
