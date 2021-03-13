//
//  OperationStateControl.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.01.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

class OperationStateControl:
    IOperationStateControl,
    IOperationControl,
    IOperationStateHolder,
    ICacheRetrievingStateControl {
    
    internal init(isManuallyTriggered: Bool) {
        self.isManuallyTriggered = isManuallyTriggered
    }
    
    
    var isManuallyTriggered: Bool
    
    var isCancelled: Bool = false
    
    var isFailed: Bool = false
    
    var isCacheAllowed: Bool = true
    
    var hasCacheApplied: Bool = false
    
    var isPaging: Bool = false
    
    static var Default: OperationStateControl {
        OperationStateControl(isManuallyTriggered: false)
    }
    
    static var ManuallyTriggered: OperationStateControl {
        OperationStateControl(isManuallyTriggered: true)
    }
    
    static var Paging: OperationStateControl {
       let control =  OperationStateControl(isManuallyTriggered: false)
        control.isPaging = true
        return control
    }
    
    func markAsFailed() {
        if isCancelled {
            return
        }
        isFailed = true
    }
    
    func markAsCancelled() {
        isCancelled = true
        isFailed = false
    }
    
    func markThatCacheApplied() {
        if isCacheAllowed {
            hasCacheApplied = true
            return
        }
        fatalError("Can't apply a cache. The cache is forbidden")
    }
}
