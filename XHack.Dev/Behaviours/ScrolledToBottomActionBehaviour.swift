//
//  ScrolledToBottomActionBehaviour.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 13.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class ScrolledToBottomActionBehaviour: ActionBehaviour {
    private let disposedBag = DisposeBag()
    private var lastEventTime: Date = .init()
    private let interval: TimeInterval
    private let smartScrollDelegate: SmartScrollBehaviour
    
    let scrolled = PublishSubject<SmartScrollArgs>()
   
    var isInitialize: Bool {
        smartScrollDelegate.isInitialize
    }
    
    init(_ scrollView: UIScrollView, _ processEventNotOftenThan: TimeInterval? = .none) {
        smartScrollDelegate = SmartScrollBehaviour(scrollView)
        interval = processEventNotOftenThan ?? TimeInterval.init(0.5)
        super.init()
        smartScrollDelegate.scrolled
            .subscribe(onNext: processScrolling)
            .disposed(by: disposedBag)
    }
    
    func initialize() {
        smartScrollDelegate.initialize()
    }
    
    func deinitialize() {
        smartScrollDelegate.deinitialize()
    }
    
    func getDistanceToBottomForFiringCommand(_ smartScrollDelegate: SmartScrollBehaviour) -> CGFloat {
        50
    }
    
    func processScrolling(_ args: SmartScrollArgs) {
        scrolled.onNext(args)
        guard args.currentDirrection == .bottom, Date().timeIntervalSince1970 - lastEventTime.timeIntervalSince1970 > interval  else { return }
        let contentOffsetY = smartScrollDelegate.scrollView.contentOffset.y
        guard contentOffsetY > 0 else { return }
        let contentHeight = smartScrollDelegate.scrollView.contentSize.height
        let frameHeight = smartScrollDelegate.scrollView.frame.height
        let distanceToBottom = getDistanceToBottomForFiringCommand(smartScrollDelegate)
        if contentHeight - (contentOffsetY + frameHeight) <= distanceToBottom {
            fire()
            lastEventTime = Date()
        }
    }
}
