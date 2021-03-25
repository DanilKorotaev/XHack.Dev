//
//  UserProfile.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 17.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class UserProfile {
    private(set) var id: Int = 0
    let name = BehaviorSubject(value:"")
    let email = BehaviorSubject(value:"")
    let isAvailableForSearching = BehaviorSubject(value: false)
    let description = BehaviorSubject(value:"")
    let specialization = BehaviorSubject(value:"")
    var tags: ObservableArray<Tag>
    let networks: [String]
    let avatarUrl: String
    var teams: ObservableArray<ShortTeam>
    
    init(_ data: UserProfileDto) {
        id = data.id
        email.onNext(data.email)
        name.onNext(data.name)
        isAvailableForSearching.onNext(data.isAvailableForSearching)
        description.onNext(data.description)
        specialization.onNext(data.specialization)
        tags = ObservableArray(data.tags.map { Tag($0) }.sorted(by: { $0.name.count < $1.name.count }))
        avatarUrl = data.avatarUrl ?? ""
        networks = data.networks
        teams = ObservableArray(data.teams.map { ShortTeam($0) })
    }
}
