//
//  HackFilterItem.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 08.01.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

protocol SelectableItem {
    var title: String { get }
    var isSelected: BehaviorSubject<Bool> { get }
}

protocol ChoosableItem {
    var title: String { get }
    var id: Int { get }
}

enum HackFilterAnswerType {
    case list([SelectableItem])
    case select([ChoosableItem])
}

class HackFilterItem {
    let question: String
    let type: HackFilterAnswerType
    
    init(question: String, type: HackFilterAnswerType) {
        self.question = question
        self.type = type
    }
}
