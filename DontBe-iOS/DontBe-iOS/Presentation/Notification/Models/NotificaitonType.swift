//
//  NotificaitonType.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/17/24.
//

import Foundation

@frozen
enum NotificaitonType: String {
    case contentLiked = "contentLiked"
    case comment = "comment"
    case commentLiked = "commentLiked"
    case actingContinue = "actingContinue"
    case beGhost = "beGhost"
    case contentGhost = "contentGhost"
    case commentGhost = "commentGhost"
    case userBan = "userBan"
    
    var description: String {
        switch self {
        case .contentLiked:
            return StringLiterals.Notification.likeContent
        case .comment:
            return StringLiterals.Notification.writeComment
        case .commentLiked:
            return StringLiterals.Notification.likeComment
        case .actingContinue:
            return StringLiterals.Notification.welcome
        case .beGhost:
            return StringLiterals.Notification.transparency
        case .contentGhost:
            return StringLiterals.Notification.contentTransparency
        case .commentGhost:
            return StringLiterals.Notification.commentTransparency
        case .userBan:
            return StringLiterals.Notification.violation
        }
    }
}
