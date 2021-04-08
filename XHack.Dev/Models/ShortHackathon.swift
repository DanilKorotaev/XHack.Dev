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
    var tags: ObservableArray<Tag>
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
        tags = ObservableArray(data.tags.map { Tag($0) }.sorted(by: { $0.name.count < $1.name.count }))
        startDate = Date.from(data.startDate)
        endDate = Date.from(data.endDate)
        dateText = "\(startDate.toString("dd.MM.yyyy")) - \(endDate.toString("dd.MM.yyyy"))"
    }
}
