//
//  CreateRequestToUserDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

struct CreateRequestToUserDto: Codable {
    let userId: Int
    let teamId: Int
}
