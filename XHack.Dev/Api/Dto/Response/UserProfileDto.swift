//
//  UserProfileDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 03.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

struct UserProfileDto: Codable {
    private(set) var id: Int
    private(set) var name: String
    private(set) var email: String
    private(set) var isAvailableForSearching: Bool
}
