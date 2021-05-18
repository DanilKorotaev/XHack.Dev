//
//  PushProcessable.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 18.05.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit

protocol PushProcessable {
    func process(data: [AnyHashable : Any], completionHandler: ((UIBackgroundFetchResult) -> Void)?) -> PushData?
}
