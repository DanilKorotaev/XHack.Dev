//
//  ShortChat.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

class ShortChat {
    let id: Int
    let name: String
    let firstUser: ShortUserDto?
    let secondUser: ShortUserDto?
    let team: ShortTeamDto?
    let type: ChatType
    let avatarUrl: String
    let lastMessage: ShortChatMessage?
    let unreadCount: Int
    private(set) var lastMessageDate: String = ""
    
    init(_ data: ShortChatDto) {
        id = data.id
        name = data.name
        firstUser = data.firstUser
        secondUser = data.secondUser
        team = data.team
        type = ChatType(rawValue: data.type) ?? .p2p
        avatarUrl = data.avatarUrl ?? ""
        if let lasMessageDto = data.messages.first {
            self.lastMessage = ShortChatMessage(lasMessageDto)
            self.lastMessageDate = lasMessageDto.createdAt.applyChatDateTimeMask()
        }else {
            self.lastMessage = .none
        }
        unreadCount = data.unreadMessageCount
    }
}
