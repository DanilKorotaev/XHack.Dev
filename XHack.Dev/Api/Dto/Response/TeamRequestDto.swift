//
//  UserToTeamRequestDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

struct TeamRequestDto: Codable {
    let id: Int
    let user: Int
    let team: ShortTeamDto
    let type: String
}
