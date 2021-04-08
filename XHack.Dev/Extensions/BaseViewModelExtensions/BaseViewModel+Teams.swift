//
//  BaseViewModel+Teams.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 05.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import PromiseKit
import RxSwift
import Swinject

fileprivate var disposedBags: [DisposeBag] = []

extension BaseViewModel {
    func selectTeam() -> Promise<SelectTeamResult> {
        Promise() { promise in
            let teamsApi = Container.resolve(ITeamsApi.self)
            let context = Container.resolve(IAppContext.self)
            let currentUserId = context.currentUser?.id
            teamsApi.getTeams().done { (result) in
                if self.checkAndProcessApiResult(response: result, "") {
                    promise.fulfill(.rejected)
                    return
                }
                guard let teamsDto = result.content  else {
                    promise.fulfill(.rejected)
                    return
                }
                let teams = teamsDto.filter { $0.captain == currentUserId}.map { ShortTeam(id: $0.id, name: $0.name, avatarUrl: $0.avatarUrl ?? "")}
                
                if teams.count == 0 {
                    promise.fulfill(.noTeams)
                    return
                }
               
                if teams.count == 1,  let team = teams.first {
                    promise.fulfill(.successful(team))
                    return
                }
                let provider = Container.resolve(MainScreeenProvider.self)
                let coordinator = Container.resolve(SelectTeamCoordinator.self)
                coordinator.navigationController = provider.navigationController
                coordinator.parameter = SelectTeamParameter(teams: teams)
                let disposedBag = DisposeBag()
                disposedBags.append(disposedBag)
                coordinator.start().subscribe(onNext: { result in
                    promise.fulfill(result)
                }).disposed(by: disposedBag)
            }
        }
    }
}
