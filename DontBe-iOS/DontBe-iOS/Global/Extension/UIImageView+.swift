//
//  UIImageView+.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/8/24.
//

import UIKit

extension UIImageView {
    func load(url: String) {
        if let url = URL(string: url) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                            self?.layer.cornerRadius = (self?.frame.size.width ?? 0) / 2.adjusted
                            self?.clipsToBounds = true
                            self?.contentMode = .scaleAspectFill
                        }
                    }
                }
            }
        }
    }
}
