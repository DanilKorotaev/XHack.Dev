//
//  PushProcessor.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 18.05.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit

class PushProcessor: PushProcessable {
    func process(data: [AnyHashable : Any], completionHandler: ((UIBackgroundFetchResult) -> Void)?) -> PushData? {
        guard let push = fetchPushData(data: data) else {
            completionHandler?(.failed)
            return nil
        }
        guard let aps = push.aps, let payload = push.payload?.value as? [String: Any] else {
            completionHandler?(.noData)
            return nil
        }
        
        switch aps.category {
        case PushNotificationData.PushCategory.newMessage:
            if let chatId = payload["chatId"] as? Int {
                completionHandler?(.newData)
                return NavigationPushData(pushNavigationData: PushChatNavigationData(chatId: chatId))
            }
            break
        default:
            completionHandler?(.noData)
            return nil
        }
        completionHandler?(.noData)
        return nil
    }
    
    private func fetchPushData(data: [AnyHashable : Any]) -> PushNotificationData? {
        guard let data = data as? [String: Any] else {
            return nil
        }
        return data.convert(PushNotificationData.self)
    }
}
