//
//  SocialLoginResponseDTO.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/14/24.
//

import Foundation

// MARK: - SocilLoginResponseDTO
struct SocialLoginResponseDTO: Decodable {
    let nickName: String
    let memberId: Int
    let accessToken, refreshToken: String
    let memberProfileUrl: String
    let isNewUser: Bool
}
