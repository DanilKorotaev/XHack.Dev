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
    var isOnline = BehaviorSubject<Bool>(value: false)
    var currentUserWillGo = BehaviorSubject<Bool>(value: false)
    
    init(_ data: HackathonDto) {
        name.onNext(data.name)
        description.onNext(data.description)
        currentUserWillGo.onNext(data.userWillGo)
        isOnline.onNext(data.isOnline)
    }
}
