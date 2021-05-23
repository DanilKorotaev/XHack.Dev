//
//  DialogActionInfo+Extension.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 23.05.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

extension DialogActionInfo {
    static var cancel: DialogActionInfo {
        DialogActionInfo(title: "Отменить", isAccented: false)
    }
}
