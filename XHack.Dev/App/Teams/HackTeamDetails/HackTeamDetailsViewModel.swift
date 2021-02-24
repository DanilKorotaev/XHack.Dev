//
//  HackTeamDetailsViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 24.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class HackTeamDetailsViewModel: BaseViewModel {
    let teamsApi: ITeamsApi
    
    let team = BehaviorSubject<Team?>(value: .none)
    let back = PublishSubject<Void>()
    var teamId: Int = 0
    
    init(teamsApi: ITeamsApi) {
        self.teamsApi = teamsApi
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        isLoading.onNext(true)
        
        teamsApi.getDetail(for: teamId).done { [weak self] (result) in
            guard let self = self else { return }
            if self.checkAndProcessApiResult(response: result, "загрузить детальную информацию команды") {
                return
            }
            guard let teamDto = result.content else {
                self.showMessage(title: "Ошибка", message: "Не удалось загрузить детальную информацию команды")
                return
            }
            self.team.onNext(Team(data: teamDto))
        }
    }
}
