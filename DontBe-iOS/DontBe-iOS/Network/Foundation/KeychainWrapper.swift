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
    
    // 토큰을 Keychain에 저장하는 함수
    // - parameter token: 저장할 토큰
    // - parameter key: Keychain에 저장될 키
    // - parameter access: 추가적인 접근 제어 설정 (기본값은 nil)
    static func saveToken(_ token: String, forKey key: String, withAccess access: SecAccessControl? = nil) {
        // 해당 키에 대한 토큰이 이미 존재하는지 확인
        if let existingToken = loadToken(forKey: key) {
            // 토큰이 이미 존재하면 업데이트 또는 필요에 따라 처리
            if existingToken != token {
                // 토큰이 다르면 업데이트
                updateToken(token, forKey: key)
            }
            return
        }

        // 토큰이 존재하지 않으면 저장 진행
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
                print("토큰을 Keychain에 저장하는 데 실패했습니다. 에러 코드: \(status)")
            }
        }
    }

    // Keychain에서 특정 키에 대한 토큰을 불러오는 함수
    // - parameter key: 불러올 토큰의 키
    // - returns: 키에 대한 토큰이 존재하면 해당 토큰을 반환, 그렇지 않으면 nil 반환
    static func loadToken(forKey key: String) -> String? {
        let query: [String: Any] = [
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
            print("Keychain에서 토큰을 불러오는 데 실패했습니다.")
            return nil
        }
    }

    // Keychain에서 특정 키에 대한 토큰을 삭제하는 함수
    // - parameter key: 삭제할 토큰의 키
    static func deleteToken(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Keychain에서 토큰을 삭제하는 데 실패했습니다.")
        }
    }

    // Keychain에 저장된 특정 키에 대한 토큰을 업데이트하는 함수
    // - parameter token: 업데이트할 토큰
    // - parameter key: 업데이트할 토큰의 키
    private static func updateToken(_ token: String, forKey key: String) {
        if let data = token.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName,
                kSecAttrAccount as String: key
            ]

            let attributes: [String: Any] = [
                kSecValueData as String: data
            ]

            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            if status != errSecSuccess {
                print("Keychain에서 토큰을 업데이트하는 데 실패했습니다. 에러 코드: \(status)")
            }
        }
    }
}
