//
//  SearchTeamViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 10.04.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class SearchTeamViewModel: BaseViewModel {
    let back = PublishSubject<Void>()
    let hackathonsApi: IHackathonsApi
    var hackId = 0
    var teams = ObservableArray<Team>()
    let teamSelect = PublishSubject<Team>()
    let filterBy = BehaviorSubject<String>(value: "")
    
    private var page = 0
    private let pageSize = 20
    private var allDataLoaded = false
    
    let refresh = PublishSubject<Void>()
    let isRefreshing = BehaviorSubject<Bool>(value: false)
    
    let loadNext = PublishSubject<Void>()
    let isPageLoading =  BehaviorSubject<Bool>(value: false)
    
    init(hackathonsApi: IHackathonsApi) {
        self.hackathonsApi = hackathonsApi
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        guard !isRefreshing.value, !isLoading.value, !isPageLoading.value else { return }
        if operationArgs.isManuallyTriggered {
            isRefreshing.onNext(true)
            page = 1
        } else if operationArgs.isPaging {
            if allDataLoaded {
                return
            }
            isPageLoading.onNext(true)
        } else {
            page = 1
            isLoading.onNext(true)
        }
        
        let dto = HackTeamListFilterDto(filter: filterBy.value, take: pageSize, page: page)
        page += 1
        
        hackathonsApi.getTeamsForHackathon(by: dto, for: hackId)
            .done { [weak self] result in
                guard let self = self else { return }
                self.isLoading.onNext(false)
                self.isRefreshing.onNext(false)
                self.isPageLoading.onNext(false)
                if self.checkAndProcessApiResult(response: result, "загрузить список команд хакатона") {
                    return
                }
                guard let content = result.content else { self.showMessage(title: "Ошибка", message: "Не удалось загрузить список команд хакатона"); return}
                if !operationArgs.isPaging {
                    self.teams.removeAll()
                }
                let teams = content.map({Team(data: $0)})
                self.allDataLoaded = teams.count < self.pageSize
                self.teams.append(contentsOf: teams)
            }
    }
    
    override func applyBinding() {
        filterBy.skip(1).bind { filter in
            self.forceContentRefreshingAsync()
        }.disposed(by: disposeBag)
        
        refresh.bind { _ in
            self.forceContentRefreshingAsync(operationArgs: OperationStateControl.ManuallyTriggered)
        }.disposed(by: disposeBag)
        
        loadNext.subscribe(onNext: { _ in
            self.forceContentRefreshingAsync(operationArgs: OperationStateControl.Paging)
        }).disposed(by: disposeBag)
    }
}
