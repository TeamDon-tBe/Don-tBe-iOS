//
//  PostDetailResponseDTO.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/17/24.
//

import Foundation

struct PostDetailResponseDTO: Decodable {
    let memberId: Int
    let memberProfileUrl: String
    let memberNickname: String
    let isGhost: Bool
    let memberGhost: Int
    let isLiked: Bool
    let time: String
    let likedNumber: Int
    let commentNumber: Int
    let contentText: String
    let isDeleted: Bool
}
