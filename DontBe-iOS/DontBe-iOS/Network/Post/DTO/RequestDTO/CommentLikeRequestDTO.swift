//
//  CommentLikeRequestDTO.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/18/24.
//

import Foundation

struct CommentLikeRequestDTO: Encodable {
    let notificationTriggerType: String
    let targetMemberId: Int
    let alarmText: String
}
