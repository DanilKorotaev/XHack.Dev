//
//  IPushSubscription.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 16.05.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

protocol IPushSubscriptionManager {
    func subscribeOnPushNotifications()
    func unsubscribeFromPushNotifications()
}
