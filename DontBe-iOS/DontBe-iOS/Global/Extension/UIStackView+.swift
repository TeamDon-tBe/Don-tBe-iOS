//
//  UIStackView+.swift
//  DontBe
//
//  Created by 변상우 on 12/26/23.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
