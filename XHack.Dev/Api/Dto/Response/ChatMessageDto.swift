//
//  ChatMessageDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 08.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

struct ChatMessageDto: Codable {
    let id: Int
    let text: String
    let createdAt: Date
    let from: ShortUserDto
    let guid: UUID
}
