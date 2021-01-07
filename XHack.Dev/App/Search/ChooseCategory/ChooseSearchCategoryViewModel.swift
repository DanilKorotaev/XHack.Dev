//
//  ChooseSearchCategoryViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 25.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class ChooseSearchCategoryViewModel: BaseViewModel {
    let didTeamSearchRequested = PublishSubject<Void>()
    let didTeammateSearchRequested = PublishSubject<Void>()
    let dismissRequested = PublishSubject<Void>()    
}
