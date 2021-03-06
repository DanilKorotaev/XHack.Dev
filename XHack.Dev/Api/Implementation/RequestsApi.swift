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
    
    func withDrawRequestToUser(userId: Int) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/teams/withDrawRequestToUser/\(userId)"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
    
    func getActiveIncomingRequests() -> Promise<ApiResult<ActiveIncomingRequestsDto>> {
        let url = endpointsProvider.gatewayUrl + "/api/teams/getActiveIncomingRequests"
        return ApiHelpers.executeReliablyGetRequest(apiTokenHolder: apiTokenHolder, url: url)
    }

    func withDrawRequestToTeam(teamId: Int) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/teams/withDrawRequestToTeam/\(teamId)"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
    
    func acceptRequestFromTeam(teamId: Int) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/teams/acceptRequestFromTeam/\(teamId)"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
    
    func sendRequest(to team: CreateRequestToTeamDto) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/teams/send-request-to-team"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url, content: team)
    }
    
    func sendRequest(to user: CreateRequestToUserDto) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/teams/send-request-to-user"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url, content: user)
    }
}
