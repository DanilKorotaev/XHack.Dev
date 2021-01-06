//
//  IncomingRequestDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 16.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

enum RequestType: String, Codable {
    case teamToUser = "TeamToUser"
    case userToTeam = "UserToTeam"
}


struct IncomingRequestDto: Codable {
    let id: Int
    let team: TeamDto
    let user: UserProfileDto
    let requestType: RequestType
}
