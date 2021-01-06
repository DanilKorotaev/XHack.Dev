//
//  ShortHackathon.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 13.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

class ShortHackathon {
    let name: String
    let description: String
    let id: Int
    let location: String
    let tags: [Tag]
    let avatarUrl: String
    let isOnline: Bool
    let startDate: Date
    let endDate: Date
    let dateText: String
    
    init(_ data:ShortHackathonDto) {
        name = data.name
        description = data.description
        id = data.id
        location = data.location
        isOnline = data.isOnline
        avatarUrl = data.avatarUrl
        tags = data.tags.map { Tag($0) }
        startDate = data.startDate
        endDate = data.endDate
        dateText = "\(startDate.toString("MM.dd.yyyy")) - \(endDate.toString("MM.dd.yyyy"))"
    }
}
