//
//  ClientEvents.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 11.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

enum ClientEvents: String {
    case sendMessage = "SendMessage"
    case authorize = "Authorize"
    case deleteMessage = "DeleteMessage"
    case readMessage = "ReadMessage"
}
