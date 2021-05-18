//
//  IPushApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 16.05.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import PromiseKit

protocol IPushApi {
    func actualizeToken(currentToken: String, oldToken: String?) -> Promise<LiteApiResult>
    func unregisterDevice(token: String) -> Promise<LiteApiResult>
}
