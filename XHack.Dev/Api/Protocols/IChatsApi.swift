//
//  IChatsApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import PromiseKit

protocol IChatsApi {
    func getChats() -> Promise<ApiResult<[ShortChatDto]>>
}
