//
//  SmartScrollBehaviour.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 13.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class SmartScrollBehaviour {
    private var contentObserver: NSKeyValueObservation? = .none
    private var _previousOffset: CGFloat = 0
    private var _previousDirection: ScrollDirection = .none
    private var _continuousScroll: CGFloat = 0
    
    let scrollView: UIScrollView
    var insets: UIEdgeInsets {
        scrollView.contentInset
    }
    var offset: CGPoint {
        scrollView.contentOffset
    }
    var contentSize: CGSize {
        scrollView.contentSize
    }
    
    private(set) var isInitialize: Bool = false
    
    let scrolled = PublishSubject<SmartScrollArgs>()
    
    init(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
    }
    
    func initialize() {
        if isInitialize {
            return
        }
        contentObserver = scrollView.observe(\UIScrollView.contentOffset, options: .new, changeHandler: onScroll)
        isInitialize = true
    }
    
    func deinitialize() {
        if !isInitialize {
            return
        }
        contentObserver?.invalidate()
        contentObserver = .none
        isInitialize = false
    }
    
    
    func onScroll(_ scrollView: UIScrollView, _ change: NSKeyValueObservedChange<CGPoint>)  {
        if !isInitialize {
            return
        }
        let currentDirrection: ScrollDirection = offset.y == _previousOffset ? _previousDirection :
            offset.y > _previousOffset ? .bottom :
            offset.y < _previousOffset ? .top :
            .none
        let force = _previousOffset - offset.y
        let directionChanged = _previousDirection != currentDirrection
        if directionChanged {
            _continuousScroll = abs(force)
        } else {
            _continuousScroll += abs(force)
        }
        
        let args = SmartScrollArgs(previousDirection: _previousDirection, currentDirrection: currentDirrection, continuousScroll: _continuousScroll, previousPosition: _previousOffset, currentPosition: offset.y)
        
        scrolled.onNext(args)
    }
    
    func scrollToTop(animated: Bool = true) {
        scrollView.setContentOffset(CGPoint(x: offset.x, y: -insets.top), animated: animated)
    }
    
    func scrollToBottom(animated: Bool = true) {
        scrollView.setContentOffset(CGPoint(x: offset.x, y: contentSize.height + insets.bottom), animated: animated)
    }
    
    
}
