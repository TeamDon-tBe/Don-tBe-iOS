//
//  UIView+.swift
//  DontBe
//
//  Created by 변상우 on 12/26/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
