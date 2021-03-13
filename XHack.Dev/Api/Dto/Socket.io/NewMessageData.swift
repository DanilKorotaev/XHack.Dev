//
//  NewMessageData.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 13.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

struct NewMessageData: Codable {
    let id: Int
    let chatId: Int
    let message: String
    let sender: ShortUserDto
//    let createdAt: Date
}
