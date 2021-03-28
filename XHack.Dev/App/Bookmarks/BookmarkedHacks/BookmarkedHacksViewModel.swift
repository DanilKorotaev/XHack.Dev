//
//  BookmarkedHacksViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 28.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class BookmarkedHacksViewModel: BaseViewModel {
    
    let bookmarksApi: IBookmarksApi
    var hackathons = ObservableArray<ShortHackathon>([])
    let hackSelect = PublishSubject<ShortHackathon>()
    
    init(bookmarksApi: IBookmarksApi) {
        self.bookmarksApi = bookmarksApi
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        isLoading.onNext(true)
        bookmarksApi.getBookmarkedHackathons().done { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading.onNext(false)
            if self.checkAndProcessApiResult(response: result) {
                return
            }
            guard let hackathonsDto = result.content else {
                return
            }
            self.hackathons.append(contentsOf: hackathonsDto.map { ShortHackathon($0) })
        }
    }
}
