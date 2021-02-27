//
//  ShortUser.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 23.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

class ShortUser {
    let id: Int
    let name: String
    let avatarUrl: String?
    
    init(id: Int, name: String, avatarUrl: String?) {
        self.id = id
        self.name = name
        self.avatarUrl = avatarUrl
    }
    
    init(_ data: ShortUserDto) {
        self.id = data.id
        self.name = data.name
        self.avatarUrl = data.avatarUrl
    }
}
