//
//  UserInfo.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/11/24.
//

import Foundation

struct UserInfo: Codable {
    let isSocialLogined: Bool
    let isFirstUser: Bool
    let isJoinedApp: Bool
    let isOnboardingFinished: Bool
    let userNickname: String
}

// 구조체를 UserDefault에 저장하는 함수
func saveUserData(_ userData: UserInfo) {
    let encoder = JSONEncoder()
    if let encodedData = try? encoder.encode(userData) {
        UserDefaults.standard.set(encodedData, forKey: "saveUserInfo")
    }
}

// UserDefault에서 구조체를 가져오는 함수
func loadUserData() -> UserInfo? {
    if let encodedData = UserDefaults.standard.data(forKey: "saveUserInfo") {
        let decoder = JSONDecoder()
        if let userData = try? decoder.decode(UserInfo.self, from: encodedData) {
            return userData
        }
    }
    return nil
}
