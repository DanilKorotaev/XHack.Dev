//
//  DefaultValuable.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 22.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

protocol DefaultValuable {
    static func defaultValue() -> Self
}

extension Int : DefaultValuable {
    static func defaultValue() -> Int {
        return 1
    }
}

extension String : DefaultValuable {
    static func defaultValue() -> String {
        return ""
    }
}

extension Array: DefaultValuable {
    static func defaultValue() -> Array {
        return []
    }
}


extension Bool: DefaultValuable {
    static func defaultValue() -> Bool {
        return false
    }
}

extension Optional: DefaultValuable {
    static func defaultValue() -> Optional {
        return nil
    }
}
