//
//  LoginViewController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/8/24.
//

import UIKit

import SnapKit

final class LoginViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let loginLogo: UIImageView = {
        let logo = UIImageView()
        logo.image = ImageLiterals.Login.icnLogo
        return logo
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
    }
}

// MARK: - Extensions

extension LoginViewController {
    private func setUI() {
        view.backgroundColor = .donWhite
    }
    
    private func setHierarchy() {
        self.view.addSubview(loginLogo)

    }
    
    private func setLayout() {
        let statusBarHeight = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .statusBarManager?
            .statusBarFrame.height ?? 20
        
        loginLogo.snp.makeConstraints {
            $0.top.equalToSuperview().inset(statusBarHeight + 41.adjusted)
            $0.leading.equalToSuperview().inset(27.adjusted)
            $0.size.equalTo(78.adjusted)
        }
    }
}
