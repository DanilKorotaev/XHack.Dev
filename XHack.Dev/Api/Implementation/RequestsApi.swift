//
//  RequestsApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 16.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

class RequestsApi: IRequestsApi {
    
    private let endpointsProvider: ApiEndpoints
    private let apiTokenHolder: IApiTokensHolder
    
    init(endpointsProvider: ApiEndpoints, apiTokenHolder: IApiTokensHolder) {
        self.endpointsProvider = endpointsProvider
        self.apiTokenHolder = apiTokenHolder
    }
    
    func acceptRequestToUser(requestId: Int) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/teams/acceptRequestToUser"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url, content: AcceptRequestToUser(requestId: requestId))
    }
    
    func declineRequestToUser(requestId: Int) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/teams/declineRequestToUser"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url, content: DeclineRequestToUserDto(requestId: requestId))
    }
    
    func withDrawRequestToUser(requestId: Int) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/teams/withDrawRequestToUser"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url, content: WithDrawRequestToUserDto(requestId: requestId))
    }
    
    func getActiveIncomingRequests() -> Promise<ApiResult<ActiveIncomingRequestsDto>> {
        let url = endpointsProvider.gatewayUrl + "/api/teams/getActiveIncomingRequests"
        return ApiHelpers.executeReliablyGetRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
}
