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
        autoregister(ApiEndpoints.self, initializer: EndpointsProvider.init).inObjectScope(.container)
        autoregister(AuthApi.self, initializer: AuthApiExecuter.init).inObjectScope(.container)
        autoregister(IApiTokensHolder.self, initializer: ApiTokensHolder.init).inObjectScope(.container)
        autoregister(ITeamsApi.self, initializer: TeamsApi.init).inObjectScope(.container)
        autoregister(IUserApi.self, initializer: UserApi.init).inObjectScope(.container)
        autoregister(IHackathonsApi.self, initializer: HackathonsApi.init).inObjectScope(.container)
        autoregister(IBookmarksApi.self, initializer: BookmarksApi.init).inObjectScope(.container)
        autoregister(ITagsApi.self, initializer: TagsApi.init).inObjectScope(.container)
        autoregister(IRequestsApi.self, initializer: RequestsApi.init).inObjectScope(.container)
        autoregister(IChatsApi.self, initializer: ChatsApi.init).inObjectScope(.container)
        autoregister(IFilesApi.self, initializer: FilesApi.init).inObjectScope(.container)
        autoregister(IPushApi.self, initializer: PushApi.init).inObjectScope(.container)
    }
}
