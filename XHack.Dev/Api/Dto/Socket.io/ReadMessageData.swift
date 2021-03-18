//
//  ReadMessageData.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 17.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import SocketIO

struct ReadMessageData: SocketData {
    let chatId: Int
    let messageId: Int
    
    func socketRepresentation() -> SocketData {
        return ["chatId": chatId,
                "messageId": messageId
        ]
    }
}
