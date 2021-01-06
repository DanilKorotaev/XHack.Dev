//
//  Tag.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 26.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

struct Tag {
    let name: String
    
    init(_ data: TagDto) {
        name = data.name
    }
}
