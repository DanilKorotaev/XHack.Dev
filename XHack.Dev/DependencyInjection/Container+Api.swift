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
    }
}
