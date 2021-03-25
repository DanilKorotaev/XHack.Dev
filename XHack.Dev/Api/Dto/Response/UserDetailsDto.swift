//
//  UserDetailsDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 03.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

struct UserDetailsDto: Codable {
    let id: Int
    let name: String
    let email: String
    let avatarUrl: String?
    let specialization: String
    let isAvailableForSearching: Bool
    let tags: [TagDto]
    let description: String
    let networks: [String]
    let isBookmarked: Bool
    let participantType: String
    let requests: [TeamRequestDto]
    let chatId: Int?
}
