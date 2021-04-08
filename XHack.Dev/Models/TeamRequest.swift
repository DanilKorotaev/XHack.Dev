//
//  TeamRequest.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

class TeamRequest {
    let id: Int
    let userId: Int
    let team: ShortTeam
    let type: RequestType
    
    init(_ data: TeamRequestDto) {
        id = data.id
        userId = data.user
        team = ShortTeam(data.team)
        type = RequestType(rawValue: data.type) ?? .none
    }
    
    init(id: Int, userId: Int, team: ShortTeam, type: RequestType) {
        self.id = id
        self.userId = userId
        self.team = team
        self.type = type
    }
}
