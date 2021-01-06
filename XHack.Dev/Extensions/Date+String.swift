//
//  Date+String.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 30.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
