//
//  SelectTeamViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 15.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class SelectTeamViewModel: BaseViewModel {
    let close = PublishSubject<Void>()
    let teamSelect = PublishSubject<ShortTeam>()
    var parameter: SelectTeamParameter!
    let teams = BehaviorSubject<[ShortTeam]>(value:[])
    
    override func initialize() {
        super.initialize()
        teams.onNext(parameter.teams)
    }
}
