//
//  ChatsApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import PromiseKit

class ChatsApi: IChatsApi {
    
    private let endpointsProvider: ApiEndpoints
    private let apiTokenHolder: IApiTokensHolder
    
    init(endpointsProvider: ApiEndpoints,apiTokenHolder: IApiTokensHolder) {
        self.endpointsProvider = endpointsProvider
        self.apiTokenHolder = apiTokenHolder
    }
    
    func getChats() -> Promise<ApiResult<[ShortChatDto]>> {
        let url = endpointsProvider.gatewayUrl + "/api/chat/chats"
        return ApiHelpers.executeReliablyGetRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
}
