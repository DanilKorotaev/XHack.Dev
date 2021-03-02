//
//  UserProfileDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 03.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

struct UserProfileDto: Codable {
    let id: Int
    let name: String
    let email: String
    let isAvailableForSearching: Bool
    let tags: [TagDto]
    let description: String
    let networks: [String]
}
