//
//  UIViewController+.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/9/24.
//

import UIKit

extension UIViewController {
    var statusBarHeight: CGFloat {
        return UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
    }
}
