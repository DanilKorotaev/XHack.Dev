//
//  UIResizableTableView.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 23.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit

class UIResizableTableView: UITableView {
    
    private var _intrinsicContentSize: CGSize = .zero
    private var _contentSizeObserver: NSKeyValueObservation!
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
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
        _contentSizeObserver = observe(\UIResizableTableView.contentSize) { [weak self] (_, _) in
            self?.updateIntrinsicContentSize()
        }
    }
    
    private func updateIntrinsicContentSize() {
        _intrinsicContentSize = contentSize
        invalidateIntrinsicContentSize()
    }
}
