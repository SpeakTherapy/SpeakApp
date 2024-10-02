//
//  KeychainManager.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/22/24.
//

import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()
    private init() {}
    
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    @discardableResult
    func save(key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func load(key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as [String: Any]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        guard status == errSecSuccess,
              let data = dataTypeRef as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }

        return value
    }
    
    @discardableResult
    func delete(key: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as [String: Any]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
