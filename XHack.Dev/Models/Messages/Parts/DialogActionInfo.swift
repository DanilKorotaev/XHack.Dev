//
//  DialogActionInfo.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

class DialogActionInfo: ActionInfo {
    let title: String
    let isAccented: Bool
    
    init(title: String, action: (() -> Void)? = nil, isAccented: Bool = true, hasClosingAnimation: Bool = true) {
        self.title = title
        self.isAccented = isAccented
        super.init(action: action, hasClosingAnimation: hasClosingAnimation)
    }
}
