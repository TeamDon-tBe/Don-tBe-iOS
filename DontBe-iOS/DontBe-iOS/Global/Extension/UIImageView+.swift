//
//  UIImageView+.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/8/24.
//

import UIKit

import Kingfisher

extension UIImageView {
    func load(url: String) {
        guard let url = URL(string: url) else { return }
        
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: nil,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        ) { result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async { [weak self] in
                    self?.image = value.image
                    self?.layer.cornerRadius = (self?.frame.size.width ?? 0) / 2.adjusted
                    self?.contentMode = .scaleAspectFill
                    self?.clipsToBounds = true
                }
            case .failure(let error):
                print("Error loading image: \(error)")
                
                DispatchQueue.main.async { [weak self] in
                    self?.layer.cornerRadius = (self?.frame.size.width ?? 0) / 2.adjusted
                    self?.contentMode = .scaleAspectFill
                    self?.clipsToBounds = true
                }
            }
        }
    }
    
    func loadContentImage(url: String) {
        if let imageUrl = URL(string: url) {
            let processor = DownsamplingImageProcessor(size: self.bounds.size)
            self.kf.indicatorType = .activity
            self.kf.setImage(
                with: imageUrl,
                placeholder: nil,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ]
            ) { result in
                switch result {
                case .success(let value):
                    DispatchQueue.main.async {
                        self.image = value.image
                        self.layer.cornerRadius = 4.adjusted
                        self.contentMode = .scaleAspectFill
                        self.clipsToBounds = true
                    }
                case .failure(let error):
                    print("Error loading image: \(error)")
                    
                    self.layer.cornerRadius = 4.adjusted
                    self.contentMode = .scaleAspectFill
                    self.clipsToBounds = true
                }
            }
        }
    }
}

//    Kingfisher 이전 이미지 로드 함수 아카이빙
//
//    func load(url: String) {
//        if let url = URL(string: url) {
//            DispatchQueue.global().async { [weak self] in
//                if let data = try? Data(contentsOf: url) {
//                    if let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            self?.image = image
//                            self?.layer.cornerRadius = (self?.frame.size.width ?? 0) / 2.adjusted
//                            self?.contentMode = .scaleAspectFill
//                            self?.clipsToBounds = true
//                        }
//                    }
//                }
//            }
//        }
//    }
    
//    func loadContentImage(url: String) {
//        if let url = URL(string: url) {
//            DispatchQueue.global().async { [weak self] in
//                if let data = try? Data(contentsOf: url) {
//                    if let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            self?.image = image
//                            self?.layer.cornerRadius = 4.adjusted
//                            self?.contentMode = .scaleAspectFill
//                            self?.clipsToBounds = true
//                        }
//                    }
//                }
//            }
//        }
//    }
