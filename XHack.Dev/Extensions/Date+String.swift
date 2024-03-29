//
//  Date+String.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 30.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

extension Date {
    
    static func from(_ iso: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US")
        return formatter.date(from: iso) ?? Date()
    }
    
    func toString(_ format: String, timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        return formatter.string(from: self)
    }
    
    func applyChatDateTimeMask() -> String {
        if Calendar.current.isDateInToday(self) {
            return self.localDate().toString("HH:mm")
        }
        if Calendar.current.isDateInYesterday(self) {
            return "ВЧЕРА"
        }
        return self.localDate().toString("dd.MM.yyyy")
    }
}
