//
//  BaseViewModel+Teams.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 05.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import PromiseKit
import Swinject

extension BaseViewModel {
    func selectTeam() -> Promise<Team?> {
        Promise() { promise in
            let teamsApi = Container.resolve(ITeamsApi.self)
            teamsApi.getTeams().done { (result) in
                if self.checkAndProcessApiResult(response: result, "") {
                    promise.fulfill(.none)
                    return
                }
                guard let teams = result.content  else {
                    promise.fulfill(.none)
                    return
                }
                if let team = teams.first {
                    promise.fulfill(Team(data: team))
                    return
                }
                promise.fulfill(.none)
            }
        }
    }
}
