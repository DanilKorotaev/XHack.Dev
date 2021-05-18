//
//  PushChatNavigationData.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 18.05.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

class PushChatNavigationData: PushNavigationData {
    let chatId: Int
    
    init(chatId: Int) {
        self.chatId = chatId
        super.init(pushCategoryType: .newMessage)
    }
}
