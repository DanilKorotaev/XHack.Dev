//
//  PushSubscriptionManager.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 16.05.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

class PushSubscriptionManager: IPushSubscriptionManager {
    
    private let pushApi: IPushApi
    private let pushSubscriptionProvider: IPushSubscriptionProvider
    
    init(pushApi: IPushApi, pushSubscriptionProvider: IPushSubscriptionProvider) {
        self.pushApi = pushApi
        self.pushSubscriptionProvider = pushSubscriptionProvider
    }
    
    func subscribeOnPushNotifications() {
        DispatchQueue.main.async {
            self.pushSubscriptionProvider.subscribeOnRecievePushNotifications { (result) in
                guard result.__conversion(), let validToken = result.currentPushToken else { return }
                print("Token: \(validToken)")
                self.pushApi.actualizeToken(currentToken: validToken, oldToken: result.oldPushToken)
            }
        }
    }
    
    func unsubscribeFromPushNotifications() {
        DispatchQueue.main.async {
            self.pushSubscriptionProvider.unSubscribeFromRecievePushNotifications()
            self.pushApi.unregisterDevice(token: self.pushSubscriptionProvider.pushToken)
        }
    }
}
