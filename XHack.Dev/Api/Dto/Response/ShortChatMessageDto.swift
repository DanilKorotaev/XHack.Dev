//
//  ShortChatMessageDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

struct ShortChatMessageDto: Codable {
    let id: Int
    let text: String
    let createdAt: Date
    let guid: UUID
}
