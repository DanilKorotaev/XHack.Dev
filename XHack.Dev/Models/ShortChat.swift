//
//  ShortChat.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

class ShortChat {
    private(set) var  id: Int?  = .none
    private(set) var  name: String
    private(set) var  firstUser: ShortUser? = .none
    private(set) var  secondUser: ShortUser?  = .none
    private(set) var  team: ShortTeam?  = .none
    private(set) var  type: ChatType
    private(set) var  avatarUrl: String
    private(set) var  lastMessage: ShortChatMessage?  = .none
    private(set) var  unreadCount: Int = 0
    private(set) var  lastMessageDate: String = ""
    
    init(_ data: ShortChatDto) {
        id = data.id
        name = data.name
        if let firstUserDto = data.firstUser {
            self.firstUser = ShortUser(firstUserDto)
        }
        if let secondUserDto = data.secondUser {
            self.secondUser = ShortUser(secondUserDto)
        }
        if let teamDto = data.team {
            self.team = ShortTeam(teamDto)
        }
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
    
    init(id: Int?, team: ShortTeam) {
        self.id = id
        name = team.name
        self.team = team
        type = .group
        avatarUrl = team.avatarUrl ?? ""
    }
}
