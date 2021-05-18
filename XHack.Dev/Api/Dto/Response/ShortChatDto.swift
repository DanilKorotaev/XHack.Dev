//
//  ShortChatDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

struct ShortChatDto: Codable {
    let id: Int
    let name: String
    let firstUser: ShortUserDto?
    let secondUser: ShortUserDto?
    let team: ShortTeamDto?
    let type: String
    let avatarUrl: String?
    let messages: [ShortChatMessageDto]?
    let unreadMessageCount: Int?
}
