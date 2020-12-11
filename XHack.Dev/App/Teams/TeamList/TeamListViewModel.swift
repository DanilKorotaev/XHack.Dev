//
//  TeamListViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 05.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class TeamListViewModel {
    private var teamsApi: ITeamsApi
    private let disposeBag = DisposeBag()

    let isLoading = BehaviorSubject(value: true)
    var teams = BehaviorSubject(value: [Team]())
    var createTask = PublishSubject<Void>()
    
    init(teamsApi: ITeamsApi) {
        self.teamsApi = teamsApi
//        fetchTasks()
    }
    
    
    func fetchTeams() {
        isLoading.onNext(true)
        teamsApi.getTeams()
            .do(onSuccess: {  [weak self] result in
                self?.isLoading.onNext(false)
                self?.teams.onNext(result.content?.map({Team(data: $0)}) ?? [])
            }).subscribe({ _ in
                
            })
            .disposed(by: disposeBag)
    }
}
