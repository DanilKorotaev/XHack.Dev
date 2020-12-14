//
//  HackathonDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

struct HackathonDto: Codable {
    let name: String
    let description: String
    let isOnline: Bool
    var userWillGo: Bool
    let teams: [TeamDto]
}
