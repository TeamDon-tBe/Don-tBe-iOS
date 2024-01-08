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
        logo.contentMode = .scaleAspectFill
        logo.clipsToBounds = true
        return logo
    }()
    
    private let loginTitle: UILabel = {
        let title = UILabel()
        title.text = StringLiterals.Login.title
        title.textColor = .black
        title.numberOfLines = 2
        title.font = .font(.head1)
        return title
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Login.btnKakao, for: .normal)
        return button
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
        self.view.addSubviews(loginLogo,
                              loginTitle,
                              loginButton)

    }
    
    private func setLayout() {
        let statusBarHeight = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .statusBarManager?
            .statusBarFrame.height ?? 20
        
        loginLogo.snp.makeConstraints {
            $0.top.equalToSuperview().inset(statusBarHeight + 65.adjustedH)
            $0.leading.equalToSuperview().inset(20.adjusted)
            $0.width.equalTo(88.adjusted)
            $0.height.equalTo(88.adjustedH)
        }
        
        loginTitle.snp.makeConstraints {
            $0.top.equalTo(loginLogo.snp.bottom).offset(20.adjustedH)
            $0.leading.equalToSuperview().inset(26.adjusted)
        }
    }
}
