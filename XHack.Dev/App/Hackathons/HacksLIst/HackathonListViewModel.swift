//
//  HackathonsListViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class HackathonListViewModel: BaseViewModel, RefreshableContentHost {
    let refresh = PublishSubject<Void>()
    let isRefreshing = BehaviorSubject<Bool>(value: false)
    
    private var page = 0
    private let pageSize = 20
    private var allDataLoaded = false
    let hackathonsApi: IHackathonsApi
    let hackathons = BehaviorSubject(value: [ShortHackathon]())
    let didSelectHack = PublishSubject<ShortHackathon>()
    let seachRequsted = PublishSubject<Void>()
    
    let loadNext = PublishSubject<Void>()
    let isPageLoading =  BehaviorSubject<Bool>(value: false)
    
    init(hackathonsApi: IHackathonsApi) {
        self.hackathonsApi = hackathonsApi
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        guard !isRefreshing.value, !isLoading.value, !isPageLoading.value else { return }
        if operationArgs.isManuallyTriggered {
            isRefreshing.onNext(true)
        } else if operationArgs.isPaging {
            isPageLoading.onNext(true)
        } else {
            isLoading.onNext(true)
        }
        
        
        let dto = HackathonsFilterDto(filter: "", take: pageSize, page: page)
        page += 1
        hackathonsApi.getHackatons(by: dto)
            .done { [weak self] result in
                guard let self = self else { return }
                self.isLoading.onNext(false)
                self.isRefreshing.onNext(false)
                self.isPageLoading.onNext(false)
                if self.checkAndProcessApiResult(response: result, "загрузить список хакатонов") {
                    return
                }
                guard let content = result.content else { self.showMessage(title: "Ошибка", message: "Не удалось загрузить список хакатонов"); return}
                self.allDataLoaded = content.count < self.pageSize
                self.hackathons.onNext(content.map({ShortHackathon($0)}))
            }
    }
    
    override func applyBinding() {
        refresh.bind { _ in
            self.forceContentRefreshingAsync(operationArgs: OperationStateControl.ManuallyTriggered)
        }.disposed(by: disposeBag)
        
        loadNext.subscribe(onNext: { _ in
            self.forceContentRefreshingAsync(operationArgs: OperationStateControl.Paging)
        }).disposed(by: disposeBag)
    }
}
