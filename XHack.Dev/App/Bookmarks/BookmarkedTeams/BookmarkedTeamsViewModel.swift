//
//  BookmarkedTeamsViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 28.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class BookmarkedTeamsViewModel: BaseViewModel {
    
    let bookmarksApi: IBookmarksApi
    var teams = ObservableArray<Team>([])
    let teamSelected = PublishSubject<Team>()
    
    init(bookmarksApi: IBookmarksApi) {
        self.bookmarksApi = bookmarksApi
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        isLoading.onNext(true)
        bookmarksApi.getBookmarkedTeams().done { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading.onNext(false)
            if self.checkAndProcessApiResult(response: result) {
                return
            }
            guard let teamsDto = result.content else {
                return
            }
            self.teams.append(contentsOf: teamsDto.map { Team(data: $0) })
        }
    }
}
