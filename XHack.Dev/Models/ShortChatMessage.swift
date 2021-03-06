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
    
    init(_ data: ShortChatMessageDto) {
        id = data.id
        text = data.text
    }
}
