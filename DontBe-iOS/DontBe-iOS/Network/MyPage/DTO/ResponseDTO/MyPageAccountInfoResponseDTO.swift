//
//  MyPageAccountInfoResponseDTO.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/14/24.
//

import Foundation

// MARK: - MyPageAccountInfoResponseDTO

struct MyPageAccountInfoResponseDTO: Decodable {
    let memberId: Int
    let joinDate: String
    let showMemberId: String?
    let socialPlatform: String
    let versionInformation: String
}
