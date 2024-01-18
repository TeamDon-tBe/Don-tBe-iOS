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
    
    func applyTabBarAttributes(to tabBarItem: UITabBarItem, isSelected: Bool) {
        let attributes: [NSAttributedString.Key: Any]
        
        if isSelected {
            attributes = [
                .font: UIFont.font(.caption3),
                .foregroundColor: UIColor.donSecondary
            ] // title이 선택되었을 때 폰트, 색상 설정
        } else {
            attributes = [
                .font: UIFont.font(.caption4),
                .foregroundColor: UIColor.donGray7
            ] // title이 선택되지 않았을 때 폰트, 색상 설정
        }
        tabBarItem.setTitleTextAttributes(attributes, for: .normal)
    }
}
