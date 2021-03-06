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
    let tags = BehaviorSubject<[TagDto]>(value:[])
    
    init(_ data: UserProfileDto) {
        id = data.id
        email.onNext(data.email)
        isAvailableForSearching.onNext(data.isAvailableForSearching)
        description.onNext(data.description)
        tags.onNext(data.tags)
    }
}
