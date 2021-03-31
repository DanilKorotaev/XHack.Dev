//
//  HackathonsFilterDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

struct HackathonsFilterDto: Codable {
    var filter: String? = ""
    var take: Int = 200
    var page: Int = 1
    var tagsIds: [Int]? = nil
}
