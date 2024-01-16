//
//  UIImageView+.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/8/24.
//

import UIKit

extension UIImageView {
    func setCircularImage(image: UIImage) {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.image = image
        self.contentMode = .scaleAspectFit
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
