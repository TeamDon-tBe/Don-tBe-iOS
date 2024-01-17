//
//  PostReplyResponseDTO.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/18/24.
//

import Foundation

// MARK: - PostReplyResponseDTO

struct PostReplyResponseDTO: Decodable {
    let commentId: Int
    let memberId: Int
    let memberProfileUrl: String
    let memberNickname: String
    let isGhost: Bool
    let memberGhost: Int
    let isLiked: Bool
    let commentLikedNumber: Int
    let commentText: String
    let time: String
}
