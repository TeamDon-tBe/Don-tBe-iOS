//
//  NotificationListResponseDTO.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/17/24.
//

import Foundation

// MARK: - NotificationListResponseDTO

struct NotificationListResponseDTO: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: [Datum]
}

// MARK: - Datum

struct Datum: Decodable {
    let memberId: Int
    let memberNickname, triggerMemberNickname: String
    let triggerMemberProfileUrl: String
    let notificationTriggerType, time: String
    let notificationTriggerId: Int
    let notificationText: String
    let isNotificationChecked: Bool
}
