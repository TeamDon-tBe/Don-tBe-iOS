//
//  NotificationList.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/17/24.
//

import Foundation

struct NotificationList {
    let memberNickname: String
    let triggerMemberNickname: String
    let triggerMemberProfileUrl: String
    let notificationTriggerId: Int
    let notificationType: NotificaitonType
    let time: String
    let notificationId: Int
}

extension NotificationList {
    static let baseList = NotificationList(memberNickname: "", 
                                           triggerMemberNickname: "",
                                           triggerMemberProfileUrl: "",
                                           notificationTriggerId: 0,
                                           notificationType: .contentLiked, 
                                           time: "",
                                           notificationId: 0)
}
