//
//  UIViewController+.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/9/24.
//

import UIKit

extension UIViewController {
    var statusBarHeight: CGFloat {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .statusBarManager?
            .statusBarFrame.height ?? 20
    }
}
