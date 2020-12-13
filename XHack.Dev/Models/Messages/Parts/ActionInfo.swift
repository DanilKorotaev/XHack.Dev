//
//  ActionInfo.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

class ActionInfo {
    
    let action: (() -> Void)?
    let hasClosingAnimation: Bool
    
    init(action: (() -> Void)?, hasClosingAnimation: Bool = true) {
        self.action = action
        self.hasClosingAnimation = hasClosingAnimation
    }
}
