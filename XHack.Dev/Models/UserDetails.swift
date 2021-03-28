//
//  UserDetails.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 02.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class UserDetails {
    
    private(set) var id: Int = 0
    let name = BehaviorSubject(value:"")
    let email = BehaviorSubject(value:"")
    let isAvailableForSearching = BehaviorSubject(value: false)
    let description = BehaviorSubject(value:"")
    let specialization = BehaviorSubject(value:"")
    var tags: ObservableArray<Tag>
    let isBookmarked = BehaviorSubject<Bool>(value: false)
    let avatarUrl: String
    let chatId: Int?
    let relationType: TeamParticipantType
    let requests: [TeamRequest]
    let networks: [String]
    
    init(_ data: UserDetailsDto) {
        id = data.id
        email.onNext(data.email)
        name.onNext(data.name)
        specialization.onNext(data.specialization)
        isAvailableForSearching.onNext(data.isAvailableForSearching)
        description.onNext(data.description)
        tags = ObservableArray(data.tags.map { Tag($0) }.sorted(by: { $0.name.count < $1.name.count }))
        isBookmarked.onNext(data.isBookmarked)
        avatarUrl = data.avatarUrl ?? ""
        relationType = TeamParticipantType(rawValue: data.participantType) ?? .none
        requests = data.requests.map { TeamRequest($0)}
        chatId = data.chatId
        networks = data.networks
    }
}
