//
//  ChatProccessable.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 10.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

protocol ChatProccessable {
    func connect()
    func sendMessage(chatId: Int?, message: String, teamId: Int?, secondUserId: Int?)
    var newMessageRecived: PublishSubject<NewMessageData> { get }
}
