//
//  ShortHackathonDto.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

struct ShortHackathonDto: Codable {
    private(set) var name: String
    private(set) var description: String
    private(set) var id: Int
}
