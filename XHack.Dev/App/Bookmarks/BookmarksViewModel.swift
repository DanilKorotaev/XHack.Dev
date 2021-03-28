//
//  BookmarksViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 28.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class BookmarksViewModel: BaseViewModel {
    
    let bookmarksApi: IBookmarksApi
    let back = PublishSubject<Void>()
    let selectedIndex = BehaviorSubject<Int>(value: 0)
    
    init(bookmarksApi: IBookmarksApi) {
        self.bookmarksApi = bookmarksApi
    }
}
