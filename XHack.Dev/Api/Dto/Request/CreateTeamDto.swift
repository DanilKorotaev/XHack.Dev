//
//  CreateTeamDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 03.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

struct CreateTeamDto: Codable {
    let name: String
    let description: String
    let avatarUrl: String?
}
