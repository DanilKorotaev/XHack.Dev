//
//  SendMEssageDate.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 11.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import SocketIO

struct SendMessageData: SocketData {
    let chatId: Int?
    let message: String
    let teamId: Int?
    let secondUserId: Int?
    let guid: UUID
    
    func socketRepresentation() -> SocketData {
        return ["chatId": chatId,
                "message": message,
                "teamId": teamId,
                "guid": "\(guid)",
                "secondUserId": secondUserId,
        ]
    }
}
