//
//  TeamListViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 05.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class TeamListViewModel: BaseViewModel {
    private var teamsApi: ITeamsApi
    
    var teams = BehaviorSubject(value: [Team]())
    var createTask = PublishSubject<Void>()
    var requestRefreshContent = PublishSubject<Void>()
    var isRefreshing = BehaviorSubject(value: false)
    
    init(teamsApi: ITeamsApi) {
        self.teamsApi = teamsApi
        super.init()
        requestRefreshContent.subscribe(onNext: {
            self.refreshContent()
        }).disposed(by: disposeBag)
    }
    
    
    override func refreshContent(_ withLoader: Bool = true) {
        if withLoader {
            isLoading.onNext(true)
        }
        
        teamsApi.getTeams()
            .do(onSuccess: {  [weak self] result in
                self?.isLoading.onNext(false)
                self?.teams.onNext(result.content?.map({Team(data: $0)}) ?? [])
            }).subscribe({ _ in
                
            })
            .disposed(by: disposeBag)
    }
}
