//
//  PostDataResponseDTO.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/16/24.
//

import Foundation

// MARK: - PostDataResponseDTO

struct PostDataResponseDTO: Decodable {
    let memberId: Int
    let memberProfileUrl: String
    let memberNickname: String
    let contentId: Int
    let contentText: String
    let time: String
    let isGhost: Bool
    let memberGhost: Int
    let isLiked: Bool
    let likedNumber: Int
    let commentNumber: Int
    let isDeleted: Bool
}
