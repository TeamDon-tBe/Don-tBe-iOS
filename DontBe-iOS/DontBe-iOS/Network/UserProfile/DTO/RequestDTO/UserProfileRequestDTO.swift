//
//  UserProfileRequestDTO.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/16/24.
//

import Foundation

// MARK: - UserProfileRequestDTO

struct UserProfileRequestDTO: Encodable {
    let nickname: String
    let is_alarm_allowed: Bool
    let member_intro: String
    let profile_url: String
}
