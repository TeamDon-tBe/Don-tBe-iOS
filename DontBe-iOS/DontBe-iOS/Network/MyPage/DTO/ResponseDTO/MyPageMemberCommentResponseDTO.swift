//
//  MyPageMemberCommentResponseDTO.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/17/24.
//

import Foundation

// MARK: - MyPageMemberCommentResponseDTO

struct MyPageMemberCommentResponseDTO: Decodable {
    let memberId: Int
    let memberProfileUrl: String
    let memberNickname: String
    let isLiked: Bool
    let isGhost: Bool
    let memberGhost: Int
    let commentLikedNumber: Int
    let commentText: String
    let time: String
    let commentId: Int
    let contentId: Int
}
