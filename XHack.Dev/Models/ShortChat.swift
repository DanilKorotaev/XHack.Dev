//
//  ShortChat.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class ShortChat: Comparable {

    private(set) var  id: Int?  = .none
    private(set) var  name: String
    private(set) var  firstUser: ShortUser? = .none
    private(set) var  secondUser: ShortUser?  = .none
    private(set) var  team: ShortTeam?  = .none
    private(set) var  type: ChatType
    private(set) var  avatarUrl: String
    let unreadCount = BehaviorSubject<Int>(value: 0)
    let lastMessage = BehaviorSubject<ShortChatMessage?>(value: .none)
    let lastMessageText = BehaviorSubject<String>(value: "")
    let lastMessageDate = BehaviorSubject<Date>(value: Date())
    let lastMessageDateText = BehaviorSubject<String>(value: "")
    
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
        if let lasMessageDto = data.messages?.first {
            self.lastMessage.onNext(ShortChatMessage(lasMessageDto))
            self.lastMessageText.onNext(lasMessageDto.text)
            self.lastMessageDate.onNext(lasMessageDto.createdAt)
            self.lastMessageDateText.onNext(lasMessageDto.createdAt.applyChatDateTimeMask())
        }
        unreadCount.onNext(data.unreadMessageCount ?? 0)
    }
    
    init(id: Int?, team: ShortTeam) {
        self.id = id
        name = team.name
        self.team = team
        type = .group
        avatarUrl = team.avatarUrl
    }
    
    init(id: Int?, user: ShortUser) {
        self.id = id
        name = user.name
        avatarUrl = user.avatarUrl
        type = .p2p
        secondUser = user
    }
    
    func update(_ lastMessage: ShortChatMessage, isCurrentUser: Bool) {
        self.lastMessage.onNext(lastMessage)
        self.lastMessageText.onNext(lastMessage.text)
        self.lastMessageDate.onNext(lastMessage.createdAt)
        self.lastMessageDateText.onNext(lastMessage.createdAt.applyChatDateTimeMask())
        if isCurrentUser {
            self.unreadCount.onNext(0)
        } else {
            self.unreadCount.increment()
        }
    }
    
    func update(_ readChat: ReadChatData) {
        self.unreadCount.onNext(0)
    }
    
    func update(_ newMessage: NewMessageData) {
        id = id ?? newMessage.chatId
    }
    
    static func < (lhs: ShortChat, rhs: ShortChat) -> Bool {
        lhs.lastMessageDate.value.compare(rhs.lastMessageDate.value) == .orderedDescending
    }
    
    static func == (lhs: ShortChat, rhs: ShortChat) -> Bool {
        lhs.lastMessageDate.value.compare(rhs.lastMessageDate.value) == .orderedSame
    }
}
