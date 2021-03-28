//
//  SentRequestsDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 27.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

struct SentRequestsDto: Codable {
    let toUsers: [SentRequestDto]
    let toTeams: [SentRequestDto]
}
