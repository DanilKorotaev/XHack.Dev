//
//  Team.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 11.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

struct TeamDetails {
    var id: Int
    var name: String
    var description: String
    var avatarUrl: String
    let chatId: Int?
    let participantType: TeamParticipantType
    let members: BehaviorSubject<[ShortUser]>
    let tags: BehaviorSubject<[Tag]>
    let isBookmarked: BehaviorSubject<Bool>
    let requests: [TeamRequest]
    
    init(data: TeamDetailsDto) {
        id = data.id
        name = data.name
        description = data.description
        avatarUrl = data.avatarUrl ?? ""
        participantType = TeamParticipantType(rawValue: data.participantType) ?? .none
        isBookmarked = BehaviorSubject<Bool>(value: data.isBookmarked)
        members = BehaviorSubject(value: data.members.map {ShortUser($0) })
        tags = BehaviorSubject(value: data.tags.map {Tag($0) })
        chatId = data.chat
        let shortTeam = ShortTeam(id: id, name: name, avatarUrl: avatarUrl)
        requests = data.requests.map { TeamRequest(id: $0.id, userId: $0.user, team: shortTeam, type: RequestType(rawValue: $0.type) ?? .none) }
    }
}
