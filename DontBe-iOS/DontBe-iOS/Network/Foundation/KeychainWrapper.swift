//
//  KeychainWrapper.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/15/24.
//

import Foundation
import Security

class KeychainWrapper {

    static let serviceName = "com.SOPT33.DontBe-iOS"
    
    static func saveToken(_ token: String, forKey key: String, withAccess access: SecAccessControl? = nil) {
        if let data = token.data(using: .utf8) {
            var query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName,
                kSecAttrAccount as String: key,
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            ]
            
            if let accessControl = access {
                query[kSecAttrAccessControl as String] = accessControl
            }

            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                print("Failed to save token to keychain")
            }
        }
    }

    static func loadToken(forKey key: String) -> String? {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var data: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &data)

        if status == errSecSuccess, let retrievedData = data as? Data {
            return String(data: retrievedData, encoding: .utf8)
        } else {
            print("Failed to load token from keychain")
            return nil
        }
    }

    static func deleteToken(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Failed to delete token from keychain")
        }
    }
}
