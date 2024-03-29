//
//  SentRequestDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 27.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

struct SentRequestDto: Codable {
    let id: Int
    let team: ShortTeamDto
    let user: ShortUserDto
    let type: String
}
