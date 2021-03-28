//
//  ShortHackathonDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

struct ShortHackathonDto: Codable {
    let name: String
    let description: String
    let isOnline: Bool
    let id: Int
    let location: String
    let siteUrl: String
    let tags: [TagDto] 
    let avatarUrl: String
    let startDate: Date
    let endDate: Date
}
