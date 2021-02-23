//
//  HackMemberListFilterDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 23.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

struct HackMemberListFilterDto: Codable {
    var filter: String? = ""
    var take: Int = 200
    var page: Int = 0
}
