//
//  HackathonsApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

class HackathonsApi: IHackathonsApi {
    private let endpointsProvider: ApiEndpoints
    private let apiTokenHolder: IApiTokensHolder
    
    init(endpointsProvider: ApiEndpoints, apiTokenHolder: IApiTokensHolder) {
        self.endpointsProvider = endpointsProvider
        self.apiTokenHolder = apiTokenHolder
    }
    
    func getHackatons(by filter: HackathonsFilterDto) -> Promise<ApiResult<[ShortHackathonDto]>> {
        let url = endpointsProvider.gatewayUrl + "/api/hackathons/get-list"
        return ApiHelpers.executeReliablyPostRequest(apiTokenHolder: apiTokenHolder, url: url, content: filter)
    }
    
    func getHackathonDetails(by id: Int) -> Promise<ApiResult<HackathonDto>> {
        let url = endpointsProvider.gatewayUrl + "/api/hackathons/get-by-id/\(id)"
        return ApiHelpers.executeReliablyGetRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
    
    func getPossibleHackatons() -> Promise<ApiResult<[ShortHackathonDto]>> {
        let url = endpointsProvider.gatewayUrl + "/api/hackathons/getPossibleHackathons"
        return ApiHelpers.executeReliablyGetRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
    
    func willGoHackathon(id: Int) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/hackathons/willGoHackathon/\(id)"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
    
    func willNotGoHackathon(id: Int) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/hackathons/willNotGoHackathon/\(id)"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
}
