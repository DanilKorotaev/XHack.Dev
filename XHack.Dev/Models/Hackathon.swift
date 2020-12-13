//
//  Hackathon.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

class HackathonDetail {
    var name: String
    var description: String
    var isOnline: Bool = false
    var currentUserWiilGo: Bool = false
    
    init(_ data: HackathonDto) {
        name = data.name
        description = data.description
    }
}
