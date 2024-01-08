//
//  SplashViewController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/7/24.
//

import UIKit

import SnapKit

final class SplashViewController: UIViewController {

    private let dontBeLogo: UIImageView = {
       let logo = UIImageView()
        logo.image = ImageLiterals.Home.textLogo
        return logo
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
    }
    
    private func setUI() {
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        self.view.addSubview(dontBeLogo)
        dontBeLogo.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(230.adjusted)
            $0.height.equalTo(35.adjusted)
        }
    }

}
