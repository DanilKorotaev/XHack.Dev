//
//  ShortChatMessage.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

class ShortChatMessage {
    let id: Int
    let text: String
    let createdAt: Date
    let guid: UUID
    
    init(_ data: ShortChatMessageDto) {
        id = data.id
        text = data.text
        createdAt = data.createdAt
        guid = data.guid
    }
    
    init(_ data: NewMessageData) {
        id = data.id
        text = data.message
        createdAt = Date()//data.createdAt
        guid = data.guid
    }
}
