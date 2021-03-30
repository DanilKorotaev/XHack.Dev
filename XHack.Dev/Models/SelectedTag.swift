//
//  SelectedTag.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 30.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class SelectedTag: Tag {
    let isSelected = BehaviorSubject<Bool>(value: false)
}
