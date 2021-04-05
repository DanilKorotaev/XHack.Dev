//
//  ParticipantRequestable.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 27.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

protocol ParticipantRequestable {
    var name: String { get }
    var avatarUrl: String { get }
    var team: ShortTeam { get }
    var user: ShortUser { get }
    var type: RequestType { get }
    var avatarPlaceholder: String { get }
}
