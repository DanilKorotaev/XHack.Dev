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
        applyBinding()
        tryRefreshContentAsync()
    }
    
    func viewCreated() { }
    
    func viewDidAppear() { }
    
    func viewWillAppear() { }
    
    func viewDidDisappear() { }
    
    func viewWillDisappear() { }
    
    func refreshContent(operationArgs: IOperationStateControl) { }
    
    func createDefaultRefreshingArgs() -> IOperationStateControl {
        OperationStateControl(isManuallyTriggered: false)
    }
    
    func forceContentRefreshingAsync(operationArgs: IOperationStateControl? = nil) {
        tryRefreshContentAsync(operationArgs: operationArgs)
    }
    
    func tryRefreshContentAsync(operationArgs: IOperationStateControl? = nil) {
        let operationArgs = operationArgs ?? createDefaultRefreshingArgs()
        if operationArgs.isCancelled {
            return
        }
        refreshContent(operationArgs: operationArgs)
        if operationArgs.isCancelled {
            return
        }
        if operationArgs.isFailed {
            clearContent(operationArgs: operationArgs)
            applyCache(operationArgs: operationArgs)
        }
    }
    
    func clearContent(operationArgs: IOperationStateControl) { }
    
    func applyCache(operationArgs: IOperationStateControl) { }
    
    func applyBinding() {}
}
