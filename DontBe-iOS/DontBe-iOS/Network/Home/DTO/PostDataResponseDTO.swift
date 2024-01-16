//
//  PostDataResponseDTO.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/16/24.
//

import Foundation

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
    
    var formatTime: String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let postDate = dateFormatter.date(from: time) {
            let components = Calendar.current.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute], from: postDate, to: Date())
            
            if let year = components.year, year > 0 {
                return "\(year)년 전"
            } else if let month = components.month, month > 0 {
                return "\(month)개월 전"
            } else if let week = components.weekOfYear, week > 0 {
                return "\(week)주 전"
            } else if let day = components.day, day > 0 {
                return "\(day)일 전"
            } else if let hour = components.hour, hour > 0 {
                return "\(hour)시간 전"
            } else if let minute = components.minute, minute == 0 {
                return "지금"
            } else if let minute = components.minute, minute > 0 {
                return "\(minute)분 전"
            } else {
                return "시간을 불러올 수 없습니다."
            }
        } else {
            return "날짜 변환 실패"
        }
    }
}
