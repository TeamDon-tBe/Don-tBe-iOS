//
//  UIApplication+.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/11/24.
//

import Foundation

import UIKit

extension UIApplication {
    
    /**
     # keyWindowInConnectedScenes
     - Note: iOS 13 keyWindow 경고 해결
     */
    var keyWindowInConnectedScenes: UIWindow? {
        if #available(iOS 13.0, *) {
           return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        } else {
           return UIApplication.shared.keyWindow
        }
    }
}
