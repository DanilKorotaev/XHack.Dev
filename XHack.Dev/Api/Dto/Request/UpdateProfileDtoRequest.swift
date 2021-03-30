//
//  UpdateProfileDtoRequest.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 03.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

struct UpdateProfileDtoRequest: Codable {
    let name: String
    let specialization: String
    let avatarUrl: String
    let description: String
    let email: String
    let networks: [String]
    let tags: [TagDto]
}
