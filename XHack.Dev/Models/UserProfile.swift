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
    private let disposeBag = DisposeBag()
    
    private(set) var id: Int = 0
    let name = BehaviorSubject(value:"")
    let email = BehaviorSubject(value:"")
    let isAvailableForSearching = BehaviorSubject(value: false)
    let description = BehaviorSubject(value:"")
    let githubLink = BehaviorSubject<String>(value:"")
    let telegramLink = BehaviorSubject<String>(value:"")
    let linkedInLink = BehaviorSubject<String>(value:"")
    let tags = BehaviorSubject<[TagDto]>(value:[])
    let socialLinks = BehaviorSubject<String>(value:"")
    
    init(_ data: UserProfileDto) {
        id = data.id
        email.onNext(data.email)
        isAvailableForSearching.onNext(data.isAvailableForSearching)
        Observable
            .combineLatest(githubLink, telegramLink, linkedInLink)
            .take(1)
            .subscribe(onNext: { self.socialLinks.onNext("\($0)\n\($1)\n\($2)") })
            .disposed(by: disposeBag)
        description.onNext(data.description)
        githubLink.onNext(data.githubLink)
        telegramLink.onNext(data.telegramLink)
        linkedInLink.onNext(data.linkedInLink)
        tags.onNext(data.tags)
    }
}
