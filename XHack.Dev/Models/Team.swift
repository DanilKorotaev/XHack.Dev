//
//  Team.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 11.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

struct Team {
    var id: Int
    var name: String
    var description: String
    var avatarUrl: String?
    let participantType: TeamParticipantType
    let members: BehaviorSubject<[ShortUser]>
    let tags: BehaviorSubject<[Tag]>
    let isBookmarked: BehaviorSubject<Bool>
    
    init(data: TeamDto) {
        id = data.id
        name = data.name
        description = data.description
        avatarUrl = data.avatarUrl
        participantType = TeamParticipantType(rawValue: data.participantType) ?? .none
        isBookmarked = BehaviorSubject<Bool>(value: data.isBookmarked)
        members = BehaviorSubject(value: data.members.map {ShortUser($0) })
        tags = BehaviorSubject(value: data.tags.map {Tag($0) })
    }
}
