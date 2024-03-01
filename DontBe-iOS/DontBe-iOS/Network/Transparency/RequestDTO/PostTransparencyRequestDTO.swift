//
//  PostTransparencyRequestDTO.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/18/24.
//

import Foundation

// MARK: - PostTransparencyRequestDTO

struct PostTransparencyRequestDTO: Encodable {
    let alarmTriggerType: String
    let targetMemberId: Int
    let alarmTriggerId: Int
    let ghostReason: String
}
