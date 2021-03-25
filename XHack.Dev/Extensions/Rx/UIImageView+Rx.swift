//
//  UIImageView+Rx.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 24.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


extension Reactive where Base: UIImageView {
    public var url: Binder<String> {
        return Binder(self.base) { imageView, url in
            imageView.downloaded(from: url)
        }
    }
}
