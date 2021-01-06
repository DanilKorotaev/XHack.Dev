//
//  RefreshableContentHost.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.01.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift


protocol RefreshableContentHost {
    var refresh: PublishSubject<Void> { get }
    var isRefreshing: PublishSubject<Bool> { get }
}
