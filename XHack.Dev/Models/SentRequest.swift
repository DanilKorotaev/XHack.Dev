//
//  SentRequest.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 27.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

class SentRequest: ParticipantRequestable {
    let team: ShortTeam
    let user: ShortUser
    let type: RequestType
    
    var name: String {
        switch (type) {
        case .teamToUser:
            return user.name
        case .userToTeam:
            return team.name
        default:
            return ""
        }
    }
    
    var avatarUrl: String {
        switch (type) {
        case .teamToUser:
            return user.avatarUrl
        case .userToTeam:
            return team.avatarUrl
        default:
            return ""
        }
    }
    
    var avatarPlaceholder: String {
        switch (type) {
        case .teamToUser:
            return "no_avatar"
        case .userToTeam:
            return "no_group_avatar"
        default:
            return ""
        }
    }
    
    init(_ data: SentRequestDto) {
        type = RequestType(rawValue: data.type) ?? .none
        team = ShortTeam(data.team)
        user = ShortUser(data.user)
    }
}
