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
    let tags = BehaviorSubject<[TagDto]>(value:[])
    let isBookmarked = BehaviorSubject<Bool>(value: false)
    let avatarUrl: String?
    let chatId: Int?
    let relationType: TeamParticipantType
    let requests: [TeamRequest]
    
    init(_ data: UserDetailsDto) {
        id = data.id
        email.onNext(data.email)
        name.onNext(data.name)
        isAvailableForSearching.onNext(data.isAvailableForSearching)
        description.onNext(data.description)
        tags.onNext(data.tags)
        isBookmarked.onNext(data.isBookmarked)
        avatarUrl = data.avatarUrl
        relationType = TeamParticipantType(rawValue: data.participantType) ?? .none
        requests = data.requests.map { TeamRequest($0)}
        chatId = data.chatId
    }
}
