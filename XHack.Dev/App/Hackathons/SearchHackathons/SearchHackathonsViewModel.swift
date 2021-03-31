//
//  HackathonsListViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class SearchHackathonsViewModel: BaseViewModel {
    let hackathonsApi: IHackathonsApi
    let hackathons = BehaviorSubject(value: [ShortHackathon]())
    let didSelectHack = PublishSubject<ShortHackathon>()
    let selectFilters = PublishSubject<Void>()
    let filtersSelected = PublishSubject<HackFilters>()
    let filterBy = PublishSubject<String>()
    let back = PublishSubject<Void>()
    private(set) var filters: HackFilters?
    private var filter = ""
    
    init(hackathonsApi: IHackathonsApi) {
        self.hackathonsApi = hackathonsApi
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        isLoading.onNext(true)
        var filterDto = HackathonsFilterDto(filter: filter)
        if let filters = filters  {
            filterDto.tagsIds = filters.tags?.map { $0.id }
        }
        hackathonsApi.getHackatons(by: filterDto)
            .done { [weak self] result in
                guard let self = self else { return }
                self.isLoading.onNext(false)
                if self.checkAndProcessApiResult(response: result, "загрузить список хакатонов") {
                    return
                }
                guard let content = result.content else { self.showMessage(title: "Ошибка", message: "Не удалось загрузить список хакатонов"); return}
                self.hackathons.onNext(content.map({ShortHackathon($0)}))
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
