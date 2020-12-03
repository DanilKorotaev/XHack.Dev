//
//  HackathonsApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class HackathonsApi: IHackathonsApi {
    
    private let endpointsProvider: ApiEndpoints
    private let apiTokenHolder: IApiTokensHolder
    
    init(endpointsProvider: ApiEndpoints, apiTokenHolder: IApiTokensHolder) {
        self.endpointsProvider = endpointsProvider
        self.apiTokenHolder = apiTokenHolder
    }
    
    func getHackatons(by filter: HackathonsFilterDto) -> Single<ApiResult<[ShortHackathonDto]>> {
        let url = endpointsProvider.gatewayUrl + "/api/hackathons/get-list"
        return ApiHelpers.executeReliablyPostRequest(apiTokenHolder: apiTokenHolder, url: url, content: filter)
    }
    
    func getHackathonDetails(by id: Int) -> Single<ApiResult<HackathonDto>> {
        let url = endpointsProvider.gatewayUrl + "/api/hackathons/\(id)"
        return ApiHelpers.executeReliablyGetRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
}
