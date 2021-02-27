//
//  TeamsApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 03.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

class TeamsApi: ITeamsApi {
    
    private let endpointsProvider: ApiEndpoints
    private let apiTokenHolder: IApiTokensHolder
    
    init(endpointsProvider: ApiEndpoints, apiTokenHolder: IApiTokensHolder) {
        self.endpointsProvider = endpointsProvider
        self.apiTokenHolder = apiTokenHolder
    }
    
    func getTeams() -> Promise<ApiResult<[TeamDto]>> {
        let url = endpointsProvider.gatewayUrl + "/api/teams/get-my-teams"
        return ApiHelpers.executeReliablyGetRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
    
    
    func create(team: CreateTeamDto) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/teams/create-team"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url, content: team)
    }
    
    func create(for hackId: Int, team: CreateTeamDto) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/teams/createTeamForHack/\(hackId)"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url, content: team)
    }
    
    func sendRequest(to team: CreateRequestToTeamDto) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/teams/send-request-to-team"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url, content: team)
    }
    
    func sendRequest(to user: CreateRequestToUserDto) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/teams/send-request-to-user"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url, content: user)
    }
    
    func getDetail(for teamId: Int) -> Promise<ApiResult<TeamDto>> {
        let url = endpointsProvider.gatewayUrl + "/api/teams/getDetails/\(teamId)"
        return ApiHelpers.executeReliablyGetRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
    
    func leave(teamId: Int) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/teams/leaveFromTeam/\(teamId)"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
}
