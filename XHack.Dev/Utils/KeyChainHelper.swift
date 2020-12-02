//
//  KeyChainHelper.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import Security

class KeyChainHelper {
    private let serviceName = "XHack.Dev".data(using: .utf8)!
    
    static let shared = KeyChainHelper()
    
    private init() { }
    
    func getValue(for key: String) -> String {
        let attributes = createRecord(for: key)
        var result: CFTypeRef? = nil
        _ = SecItemCopyMatching(attributes, &result)
        if let result = result, result as! Int32 == errSecSuccess {
            return ""
        }
        return result?.value ?? ""
    }
    
    
    func set(value: String, for key: String) -> Bool {
        if !getValue(for: key).hasNonEmptyValue() {
            removeKey(key)
        }
        let attributes = createKeyValueRecord(key, value)
        var result: CFTypeRef? = nil
        _ = SecItemAdd(attributes, &result)
        if let result = result, result as! Int32 == errSecSuccess {
            return false
        }
        return true
    }
    
    func removeKey(_ key: String) {
        let attributes = createRecord(for: key)
        _ = SecItemDelete(attributes)
    }
    
    
    private func createRecord(for key: String) -> CFDictionary {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecAttrService as String : serviceName,
            kSecAttrLabel as String   : key] as [String : Any]
        return query as CFDictionary
    }
    
    private func createKeyValueRecord(_ key:String, _ value: String) -> CFDictionary  {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecAttrService as String : serviceName,
            kSecValueData as String   : value.data(using: .utf8)!,
            kSecAttrLabel as String   : key] as [String : Any]
        return query as CFDictionary
    }
}
