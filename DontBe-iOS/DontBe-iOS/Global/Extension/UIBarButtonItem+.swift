//
//  UIBarButtonItem+.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/12/24.
//

import UIKit

import SnapKit

extension UIBarButtonItem {
    static func backButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let backButton = UIBarButtonItem(
            image: ImageLiterals.Common.btnBack.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: target,
            action: action
        )
        return backButton
    }
}
