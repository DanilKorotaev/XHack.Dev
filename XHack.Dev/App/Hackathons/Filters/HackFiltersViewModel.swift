//
//  HackFiltersViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 31.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class HackFiltersViewModel: BaseViewModel {
    let back = PublishSubject<Void>()
    let save = PublishSubject<Void>()
    let selectTags = PublishSubject<Void>()
    let isOnline = BehaviorSubject<Bool>(value: false)
    let tagsSelected = PublishSubject<[Tag]>()
    var filters: HackFilters!
    var parameter: HackFiltersParameter?
    
    override func initialize() {
        super.initialize()
        guard let filters = parameter?.filters else {
            self.filters = HackFilters(tags: nil, isOnline: nil)
            return
        }
        self.filters = parameter?.filters
        isOnline.onNext(filters.isOnline ?? true)
    }
    
    override func applyBinding() {
        tagsSelected.bind { [weak self] tags in
            self?.filters.tags = tags
        }.disposed(by: disposeBag)
    }
}
