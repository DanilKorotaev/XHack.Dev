//
//  BaseViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel {
    let isLoading = BehaviorSubject(value: false)
    let disposeBag = DisposeBag()
    
    func initialize() {
        refreshContent()
    }
    
    func refreshContent() { }
}
