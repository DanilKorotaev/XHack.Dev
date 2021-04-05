//
//  MemberListViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 23.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

struct HackMemberFilters {
    var tags: [Tag]?
}

class HackMemberListViewModel: BaseViewModel {
    let hackathonsApi: IHackathonsApi
    let memberSelected = PublishSubject<ShortUser>()
    let back = PublishSubject<Void>()
    let selectFilters = PublishSubject<Void>()
    let filtersSelected = PublishSubject<HackMemberFilters>()
    let filterBy = PublishSubject<String>()
    let members = BehaviorSubject<[ShortUser]>(value: [])
    var hackId = 0
    private var filter = ""
    private(set) var filters = HackMemberFilters()
    
    init(hackathonsApi: IHackathonsApi) {
        self.hackathonsApi = hackathonsApi
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        isLoading.onNext(true)
        var filterDto = HackMemberListFilterDto(filter: filter)
        filterDto.tagIds = filters.tags?.map { $0.id }
        hackathonsApi.getUsersForHackathon(by: filterDto, for: hackId)
            .done { [weak self] result in
                guard let self = self else { return }
                self.isLoading.onNext(false)
                if self.checkAndProcessApiResult(response: result, "загрузить список участников хакатона") {
                    return
                }
                guard let content = result.content else { self.showMessage(title: "Ошибка", message: "Не удалось загрузить список участников хакатона"); return}
                self.members.onNext(content.map({ShortUser($0)}))
            }
    }
    
    
    override func applyBinding() {
        filterBy.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            self.filter = result
            self.forceContentRefreshingAsync()
        }).disposed(by: disposeBag)
        
        filtersSelected.bind { [weak self] filters in
            self?.filters = filters
            self?.forceContentRefreshingAsync(operationArgs: OperationStateControl.Default)
        }.disposed(by: disposeBag)
    }
}
