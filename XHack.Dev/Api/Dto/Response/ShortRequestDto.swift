//
//  ShortRequestDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 08.04.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

struct ShortRequestDto: Codable {
    let id: Int
    let user: Int
    let type: String
}
