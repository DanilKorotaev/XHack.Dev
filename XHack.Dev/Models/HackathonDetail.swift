//
//  Hackathon.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class HackathonDetail {
    var name = BehaviorSubject<String>(value: "")
    var description = BehaviorSubject<String>(value: "")
    let teams = BehaviorSubject<[ShortTeam]>(value:[])
    let members = BehaviorSubject<[ShortUser]>(value:[])
    let startDate: Date
    let endDate: Date
    let location: String
    let isOnline: Bool
    let dateText: String
    let avatarUrl: String
    let siteUrl: String
    let isBookmarked: BehaviorSubject<Bool>
    var tags: ObservableArray<Tag>
    let participationType: HackParticipationType
    
    init(_ data: HackathonDto) {
        name.onNext(data.name)
        description.onNext(data.description)
        isOnline = data.isOnline
        startDate = data.startDate
        endDate = data.endDate
        location = data.location
        avatarUrl = data.avatarUrl
        tags = ObservableArray(data.tags.map { Tag($0) }.sorted(by: { $0.name.count < $1.name.count }))
        participationType = HackParticipationType(rawValue: data.participationType) ?? .none
        siteUrl = data.siteUrl
        isBookmarked = BehaviorSubject<Bool>(value: data.isBookmarked)
        teams.onNext(data.teams.map {ShortTeam($0) })
        members.onNext(data.members.map {ShortUser($0) })
        dateText = "\(startDate.toString("dd.MM.yyyy")) - \(endDate.toString("dd.MM.yyyy"))"
    }
}
