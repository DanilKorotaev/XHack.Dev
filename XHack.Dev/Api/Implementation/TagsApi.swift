//
//  TagsApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 15.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

class TagsApi: ITagsApi {
    
    private let endpointsProvider: ApiEndpoints
    private let apiTokenHolder: IApiTokensHolder
    
    init(endpointsProvider: ApiEndpoints, apiTokenHolder: IApiTokensHolder) {
        self.endpointsProvider = endpointsProvider
        self.apiTokenHolder = apiTokenHolder
    }
    
    func addTags(_ tagIds: [Int]) -> Promise<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/tags/addTagsForUser"
        return ApiHelpers.executeReliablyLiteDeleteRequest(apiTokenHolder: apiTokenHolder, url: url, content: AddTagsDto(tagIds: tagIds))
    }
}
