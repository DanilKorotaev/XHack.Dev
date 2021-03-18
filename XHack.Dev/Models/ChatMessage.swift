//
//  ChatMessage.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 08.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

class ChatMessage {
    let id: Int?
    let text: String
    let date: Date
    let isIncoming: Bool
    let user: ShortUser
    let guid: UUID
    
    init(_ data: ChatMessageDto, isIncoming: Bool) {
        id = data.id
        text = data.text
        user = ShortUser(data.from)
        date = data.createdAt
        self.isIncoming = isIncoming
        guid = data.guid
    }
    
    init(_ data: NewMessageData, isIncoming: Bool) {
        id = data.id
        text = data.message
        user = ShortUser(data.sender)
        date = Date()//data.createdAt
        self.isIncoming = isIncoming
        guid = data.guid
    }
    
    init(text: String, guid: UUID, user: ShortUser) {
        self.text = text
        self.user = user
        isIncoming = false
        date = Date()
        id = .none
        self.guid = guid
    }
}
