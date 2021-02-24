//
//  Team.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 11.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

struct Team {
    var id: Int
    var name: String
    var description: String
    var avatarUrl: String?
    
    init(data: TeamDto) {
        id = data.id
        name = data.name
        description = data.description
        avatarUrl = data.avatarUrl
    }
}
