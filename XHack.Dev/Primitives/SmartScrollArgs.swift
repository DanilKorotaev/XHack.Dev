//
//  SmartScrollArgs.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 13.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit

struct SmartScrollArgs {
    let previousDirection: ScrollDirection
    let currentDirrection: ScrollDirection
    let continuousScroll: CGFloat
    let previousPosition: CGFloat
    let currentPosition: CGFloat
    
    var force: CGFloat {
        previousPosition - currentPosition
    }
    
    var directionChanged: Bool {
        previousDirection != currentDirrection
    }
}
