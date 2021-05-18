//
//  PushApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 16.05.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import PromiseKit

class PushApi: IPushApi {
    
    private let endpointsProvider: ApiEndpoints
    private let apiTokenHolder: IApiTokensHolder
    
    init(endpointsProvider: ApiEndpoints,apiTokenHolder: IApiTokensHolder) {
        self.endpointsProvider = endpointsProvider
        self.apiTokenHolder = apiTokenHolder
    }
    
    func actualizeToken(currentToken: String, oldToken: String?) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/notifications/actualizeToken"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url, content: ["currentToken": currentToken, "oldToken" : oldToken])
    }
    
    
    func unregisterDevice(token: String) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/notifications/unregisterDevice"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url, content: ["token": token])
    }
}
