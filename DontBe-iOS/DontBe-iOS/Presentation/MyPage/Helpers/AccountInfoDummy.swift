//
//  AccountInfoDummy.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/14/24.
//

import Foundation

struct AccountInfoDummy {
    let content: String
}

extension AccountInfoDummy {
    static func dummy() -> [AccountInfoDummy] {
        return [
            AccountInfoDummy(content: "카카오톡 소셜로그인"),
            AccountInfoDummy(content: "v.1.0.01"),
            AccountInfoDummy(content: "money_rain_is_coming"),
            AccountInfoDummy(content: "2024.01.14")
        ]
    }
}
