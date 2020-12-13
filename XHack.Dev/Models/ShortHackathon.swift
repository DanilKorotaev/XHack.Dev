//
//  ShortHackathon.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 13.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

class ShortHackathon {
    private(set) var name: String
    private(set) var description: String
    private(set) var id: Int
    
    init(_ data:ShortHackathonDto) {
        name = data.name
        description = data.description
        id = data.id
    }
}
