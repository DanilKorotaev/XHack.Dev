//
//  Dictionary+JsonParse.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 13.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

extension Dictionary where Key == String {
    func convert<T:Codable>(_ type: T.Type) -> T? {
        do {
            let json = try JSONSerialization.data(withJSONObject: self)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let object = try decoder.decode(type.self, from: json)
            return object
        } catch {
            print(error)
        }
        return nil
    }
}
