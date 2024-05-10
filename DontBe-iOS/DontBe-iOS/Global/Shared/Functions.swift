//
//  Functions.swift
//  DontBe-iOS
//
//  Created by 변상우 on 5/9/24.
//

import UIKit

func adjustGhostValue(_ value: Int) -> Int {
    switch value {
        case ...(-80):
            return -85
        case -81...(-70):
            return -80
        case -71...(-60):
            return -70
        case -61...(-50):
            return -60
        case -51...(-40):
            return -50
        case -41...(-30):
            return -40
        case -31...(-20):
            return -30
        case -21...(-10):
            return -20
        case -11...(-1):
            return -10
        default:
            return value
    }
}
