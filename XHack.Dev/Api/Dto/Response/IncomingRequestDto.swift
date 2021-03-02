//
//  IncomingRequestDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 16.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation


struct IncomingRequestDto: Codable {
    let id: Int
    let team: ShortTeamDto
    let user: ShortUserDto
    let type: String
}
