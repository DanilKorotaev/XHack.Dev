//
//  TeamDetailsDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 28.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

struct TeamDetailsDto: Codable {
    var id: Int
    var name: String
    var description: String
    var avatarUrl: String?
    let members : [ShortUserDto]
    var isBookmarked: Bool = true
    let chat: Int?
    let participantType: String
    let requests: [ShortRequestDto]
    let tags: [TagDto] = []
}
