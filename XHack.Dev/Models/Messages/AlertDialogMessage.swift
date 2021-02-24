//
//  AlertDialogMessage.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit

class AlertDialogMessage: Message, Equatable {
    let dialogActions: [DialogActionInfo]
    let title: String
    let message: String
    let style: UIAlertController.Style
    
    init(title: String, message: String, dialogActions: [DialogActionInfo], style: UIAlertController.Style = .alert) {
        self.message = message
        self.title = title
        self.dialogActions = dialogActions
        self.style = style
    }
    
    static func == (lhs: AlertDialogMessage, rhs: AlertDialogMessage) -> Bool {
        return lhs.title == rhs.title && lhs.message == rhs.message
    }
}
