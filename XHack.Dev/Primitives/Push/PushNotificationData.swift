//
//  PushNotificationData.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 18.05.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

struct PushNotificationData: Codable {
    let aps: ApsData?
    let payload: AnyCodable?
    
    struct ApsData: Codable {
        let badge: Int?
        let sound: String
        let category: String
        let collapseId: String?
    }
    
    struct PushCategory {
        static let newMessage = "NEW_MESSAGE"
        static let newRequestToTeam = "NEW_REQUEST_TO_TEAM"
        static let newRequestToUser = "NEW_REQUEST_TO_USER"
    }
}
