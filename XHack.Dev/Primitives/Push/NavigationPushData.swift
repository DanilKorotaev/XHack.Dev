//
//  NavigationPushData.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 18.05.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

class NavigationPushData : PushData {
    var data : Any {
        pushNavigationData
    }
    
    let pushNavigationData : PushNavigationData
    
    init(pushNavigationData: PushNavigationData) {
        self.pushNavigationData = pushNavigationData
    }
}
