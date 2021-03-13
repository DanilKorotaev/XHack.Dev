//
//  PageLoadingBehaviour.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 13.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class PageLoadingBehaviour: ScrolledToBottomActionBehaviour {
    private var target: PageLoadingTarget
    private let disposedBag = DisposeBag()
    
    private(set) lazy var isLoading: PublishSubject<Bool> = {
        var isLoading = PublishSubject<Bool>()
        isLoading.observeOn(MainScheduler.instance)
            .bind { value in
            self.target.isLoading = value
        }.disposed(by: disposedBag)
        return isLoading
    }()
    
    init(_ target: PageLoadingTarget, _ processEventNotOftenThan: TimeInterval? = .none) {
        self.target = target
        super.init(target.scrollView, processEventNotOftenThan)
    }
    
    override func getDistanceToBottomForFiringCommand(_ smartScrollDelegate: SmartScrollBehaviour) -> CGFloat {
        smartScrollDelegate.scrollView.frame.height * 2
    }
}
