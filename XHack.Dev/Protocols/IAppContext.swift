//
//  IAppContext.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 02.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import PromiseKit

protocol IAppContext {
    var currentUser: UserProfile? { get }
    
    func updateUserData() -> Promise<Bool>
}
