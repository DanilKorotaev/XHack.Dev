//
//  Team.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 28.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class Team {
    var id: Int
    var name: String
    var description: String
    var avatarUrl: String?
    let members: [ShortUser]
    let tags: BehaviorSubject<[Tag]>
    
    init(data: TeamDto) {
        id = data.id
        name = data.name
        description = data.description
        avatarUrl = data.avatarUrl
        members = data.members.map {ShortUser($0) }
        tags = BehaviorSubject(value: data.tags.map {Tag($0) })
    }
}
