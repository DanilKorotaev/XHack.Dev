//
//  UIView+Extensions.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 09.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setRotation(_ angle: CGFloat) {
        var angle = angle
        if angle < 0 {
            angle = 360 - angle
        }
        self.transform = CGAffineTransform(rotationAngle: angle * CGFloat(Double.pi) / 180)
    }
}
