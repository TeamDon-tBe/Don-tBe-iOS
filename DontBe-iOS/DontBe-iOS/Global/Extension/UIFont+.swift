//
//  UIFont+.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/6/24.
//

import UIKit

enum FontName: String {
    case head1, head2, head3
    case body1, body2, body3, body4
    case caption1, caption2, caption3, caption4

    var rawValue: String {
        switch self {
        case .head1, .head2, .head3, .body1, .body3, .caption1, .caption3: return "Pretendard-SemiBold"
        case .body2, .body4, .caption2, .caption4: return "Pretendard-Regular"
        }
    }

    var size: CGFloat {
        switch self {
        case .head1: return 24.adjusted
        case .head2: return 20.adjusted
        case .head3: return 18.adjusted
        case .body1, .body2: return 16.adjusted
        case .body3, .body4: return 14.adjusted
        case .caption1, .caption2: return 13.adjusted
        case .caption3, .caption4: return 12.adjusted
        }
    }
}

extension UIFont {
    static func font(_ style: FontName) -> UIFont {
        return UIFont(name: style.rawValue, size: style.size)!
    }
}
