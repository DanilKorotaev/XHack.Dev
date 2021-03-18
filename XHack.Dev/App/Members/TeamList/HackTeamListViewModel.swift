//
//  TeamListViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 23.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class HackTeamListViewModel: BaseViewModel {
    let hackathonsApi: IHackathonsApi
    let teamSelected = PublishSubject<Team>()
    let back = PublishSubject<Void>()
    let filterBy = PublishSubject<String>()
    var teams = ObservableArray<Team>([])
    var hackId = 0
    private var filter = ""
    
    init(hackathonsApi: IHackathonsApi) {
        self.hackathonsApi = hackathonsApi
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        isLoading.onNext(true)
        hackathonsApi.getTeamsForHackathon(by: HackTeamListFilterDto(filter: filter), for: hackId)
            .done { [weak self] result in
                guard let self = self else { return }
                self.isLoading.onNext(false)
                if self.checkAndProcessApiResult(response: result, "загрузить список команд хакатона") {
                    return
                }
                guard let content = result.content else { self.showMessage(title: "Ошибка", message: "Не удалось загрузить список команд хакатона"); return}
                let teams = content.map({Team(data: $0)})
                self.teams.append(contentsOf: teams)
            }
    }
    
    
    override func applyBinding() {
        filterBy.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            self.filter = result
            self.forceContentRefreshingAsync()
        }).disposed(by: disposeBag)
    }
}
