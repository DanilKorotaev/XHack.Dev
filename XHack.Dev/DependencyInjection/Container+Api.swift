//
//  Container+Api.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import Swinject

extension Container {
    func registerApi() {
        autoregister(ApiEndpoints.self, initializer: EndpointsProvider.init)
        autoregister(AuthApi.self, initializer: AuthApiExecuter.init)
        autoregister(IApiTokensHolder.self, initializer: ApiTokensHolder.init)
        autoregister(ITeamsApi.self, initializer: TeamsApi.init)
        autoregister(IUserApi.self, initializer: UserApi.init)
        autoregister(IHackathonsApi.self, initializer: HackathonsApi.init)
        autoregister(IBookmarksApi.self, initializer: BookmarksApi.init)
        autoregister(ITagsApi.self, initializer: TagsApi.init)
        autoregister(IRequestsApi.self, initializer: RequestsApi.init)
        autoregister(IChatsApi.self, initializer: ChatsApi.init)
        autoregister(IFilesApi.self, initializer: FilesApi.init)
    }
}
