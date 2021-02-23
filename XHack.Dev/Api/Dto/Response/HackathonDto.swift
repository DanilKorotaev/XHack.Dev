//
//  HackathonDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

struct HackathonDto: Codable {
    let id: Int
    let name: String
    let description: String
    let isOnline: Bool
    var userWillGo: Bool
    let location: String
    let siteUrl: String
    let avatarUrl: String
    let startDate: Date
    let endDate: Date
    let tags: [TagDto]
    let teams: [ShortTeamDto]
    let members : [ShortUserDto] = []
}
