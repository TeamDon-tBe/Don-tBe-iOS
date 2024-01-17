//
//  String+.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/11/24.
//

import Foundation

extension String {
    // 글자가 자음인지 체크
    var isConsonant: Bool {
        guard let scalar = UnicodeScalar(self)?.value else {
            return false
        }
        let consonantScalarRange: ClosedRange<UInt32> = 12593...12622
        return consonantScalarRange ~= scalar
    }
    
    func formattedTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let postDate = dateFormatter.date(from: self) {
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
            } else if let minute = components.minute, minute >= 1 {
                return "\(minute)분 전"
            } else {
                return "방금"
            }
        } else {
            return "날짜 변환 실패"
        }
    }
}
