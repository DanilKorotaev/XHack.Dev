//
//  IAlertDispatcher.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 13.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

protocol IAlertDispatcher {
    func dispatch(message: AlertDialogMessage)
}
