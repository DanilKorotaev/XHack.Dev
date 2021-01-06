//
//  IOperationControl.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.01.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

protocol IOperationControl: IOperationStateHolder {
    func markAsFailed()
    func markAsCancelled()
}

extension IOperationControl {
    func isAlive() -> Bool {
        !self.isCancelled && !self.isFailed
    }
}
