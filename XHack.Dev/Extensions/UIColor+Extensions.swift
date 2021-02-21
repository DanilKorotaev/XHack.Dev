//
//  UIColor+Extentions.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 21.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init(hex: String) {
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    let r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    let g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    let b = CGFloat((hexNumber & 0x0000ff) >> 4) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }
        fatalError("Hex should started with '#'")
    }
}
