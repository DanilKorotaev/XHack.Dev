//
//  ICacheRetrievingStateControl.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.01.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

protocol ICacheRetrievingStateControl: IOperationStateHolder {
    var isCacheAllowed: Bool { get }
    var hasCacheApplied: Bool { get }
    func markThatCacheApplied()
}
