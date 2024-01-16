//
//  MypageProfileResponseDTO.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/16/24.
//

import Foundation

// MARK: - MypageProfileResponseDTO

struct MypageProfileResponseDTO: Decodable {
    let memberId: Int
    let nickname: String
    let memberProfileUrl: String
    let memberIntro: String
    let memberGhost: Int
}
