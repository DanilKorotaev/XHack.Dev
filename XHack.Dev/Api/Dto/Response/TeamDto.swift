//
//  TeamDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 03.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

struct TeamDto: Codable {
    var id: Int
    var name: String
    var description: String
    var avatarUrl: String?
    let members : [ShortUserDto]
    var isBookmarked: Bool = true
    let participantType: String
    let tags: [TagDto] = []
}
