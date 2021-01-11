//
//  HackFilterDialogViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 07.01.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class HackFilterDialogViewModel: BaseViewModel {
    let backRequest = PublishSubject<Void>()
    let skipRequest = PublishSubject<Void>()
    let applyFilterRequest = PublishSubject<Void>()
    let nextFilter = PublishSubject<Void>()
}
