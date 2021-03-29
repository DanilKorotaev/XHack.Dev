//
//  UpdateTeamDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

struct UpdateTeamDto: Codable {
    let name: String
    let description: String
    let avatarUrl: String?
}
