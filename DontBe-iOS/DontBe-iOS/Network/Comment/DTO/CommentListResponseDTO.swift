//
//  CommentListResponseDTO.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/18/24.
//

import Foundation

struct CommentListResponseDTO: Decodable {
    let commentId: Int
    let memberId: Int
    let memberProfileUrl: String
    let memberNickname: String
    let isGhost: Int
    let memberGhost: Int
    let isLiked: Bool
    let commentLikedNumber: Int
    let commentText: String
    let time: String
}
