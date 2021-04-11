//
//  BookmarkedUsersViwModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 28.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class BookmarkedUsersViewModel: BaseViewModel {
    
    let bookmarksApi: IBookmarksApi
    var users = ObservableArray<ShortUser>([])
    let memberSelected = PublishSubject<ShortUser>()
    
    let refresh = PublishSubject<Void>()
    let isRefreshing = BehaviorSubject<Bool>(value: false)
    
    init(bookmarksApi: IBookmarksApi) {
        self.bookmarksApi = bookmarksApi
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        guard !isRefreshing.value, !isLoading.value else { return }
        if operationArgs.isManuallyTriggered {
            isRefreshing.onNext(true)
        } else {
            isLoading.onNext(true)
        }
        bookmarksApi.getBookmarkedUsers().done { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading.onNext(false)
            self.isRefreshing.onNext(false)
            if self.checkAndProcessApiResult(response: result) {
                return
            }
            guard let usersDto = result.content else {
                return
            }
            if operationArgs.isManuallyTriggered {
                self.users.removeAll()
            }
            self.users.append(contentsOf: usersDto.map { ShortUser($0) })
        }
    }
    
    override func applyBinding() {
        refresh.bind { [weak self] _ in
            self?.forceContentRefreshingAsync(operationArgs: OperationStateControl.ManuallyTriggered)
        }.disposed(by: disposeBag)
    }
}
