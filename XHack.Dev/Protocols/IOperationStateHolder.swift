//
//  IOperationStateHolder.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.01.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

protocol IOperationStateHolder {
    var isManuallyTriggered: Bool { get }
    var isCancelled: Bool { get }
    var isFailed: Bool { get }
}
