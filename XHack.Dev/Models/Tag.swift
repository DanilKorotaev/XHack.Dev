//
//  Tag.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 26.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

class Tag {
    let id: Int
    let name: String
    
    init(_ data: TagDto) {
        name = data.name
        id = data.id
    }
    
    init(_ tag: Tag) {
        name = tag.name
        id = tag.id
    }
    
    init(id: Int, name: String) {
        self.name = name
        self.id = id
    }
}
