//
//  IncomingRequest.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 28.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

enum RequestType: String {
    case none
    case teamToUser = "TeamToUser"
    case userToTeam = "UserToTeam"
}

class IncomingRequest {
    let team: ShortTeam
    let user: ShortUser
    let type: RequestType
    
    var name: String {
        switch (type) {
        case .teamToUser:
            return team.name
        case .userToTeam:
            return user.name
        default:
            return ""
        }
    }
    
    var avatarUrl: String? {
        switch (type) {
        case .teamToUser:
            return team.avatarUrl
        case .userToTeam:
            return user.avatarUrl
        default:
            return ""
        }
    }
    
    init(_ data: IncomingRequestDto) {
        type = RequestType(rawValue: data.type) ?? .none
        team = ShortTeam(data.team)
        user = ShortUser(data.user)
    }
}
