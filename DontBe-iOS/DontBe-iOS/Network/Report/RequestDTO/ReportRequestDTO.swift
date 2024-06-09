//
//  ReportRequestDTO.swift
//  DontBe-iOS
//
//  Created by 변상우 on 6/9/24.
//

import Foundation

// MARK: - ReportRequestDTO

struct ReportRequestDTO: Encodable {
    let reportTargetNickname: String
    let relateText: String
}
