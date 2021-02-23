//
//  BehaviourSubject+Extensions.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 22.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

extension BehaviorSubject where Element: DefaultValuable {
    var value: Element {
        return (try? self.value()) ?? Element.defaultValue()
    }
}


extension BehaviorSubject where Element == Bool {
    func invert() {
        self.onNext(self.invertValue)
    }
    
    var invertValue: Bool {
        return !self.value
    }
}
