//
//  UIResizableCollectionView.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 25.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class UIResizableCollectionView: UICollectionView {
    
    private var _intrinsicContentSize: CGSize = .zero
    private var _contentSizeObserver: NSKeyValueObservation!
    
    let contentSizeChanged = PublishSubject<CGSize>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initalize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initalize()
    }
    
    override var intrinsicContentSize: CGSize {
        _intrinsicContentSize
    }
    
    override var isScrollEnabled: Bool {
        get {
            false
        }
        set {
            //do nothing
        }
    }
    
    private func initalize() {
        super.isScrollEnabled = false
        _contentSizeObserver = observe(\UIResizableCollectionView.contentSize) { [weak self] (_, _) in
            self?.updateIntrinsicContentSize()
        }
    }
    
    private func updateIntrinsicContentSize() {
        _intrinsicContentSize = contentSize
        invalidateIntrinsicContentSize()
        contentSizeChanged.onNext(contentSize)
    }
}
