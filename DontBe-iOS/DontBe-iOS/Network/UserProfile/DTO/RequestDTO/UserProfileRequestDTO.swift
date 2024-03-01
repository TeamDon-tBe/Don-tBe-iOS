//
//  UserProfileRequestDTO.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/16/24.
//

import Foundation
import UIKit

// MARK: - UserProfileRequestDTO

struct UserProfileRequestDTO: Encodable {
    let nickname: String
    let is_alarm_allowed: Bool
    let member_intro: String
    let profile_url: String
}

struct EditUserProfileRequestDTO {
    let nickname: String
    let is_alarm_allowed: Bool
    let member_intro: String
    let profile_image: UIImage
}
