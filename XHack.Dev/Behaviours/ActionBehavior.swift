//
//  ActionBehavior.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 13.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class ActionBehaviour {
    
    var command: PublishSubject<Void>? = .none
    
    func fire() {
        guard let command = command else {
            return
        }
        command.onNext(())
    }
}
