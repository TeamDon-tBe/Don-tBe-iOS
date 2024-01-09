//
//  OnboardingEndingViewController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/9/24.
//

import UIKit

import SnapKit

final class OnboardingEndingViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let progressImage: UIImageView = {
        let progress = UIImageView()
        progress.image = ImageLiterals.Onboarding.progressbar4
        return progress
    }()
    
    private let titleImage: UIImageView = {
        let title = UIImageView()
        title.image = ImageLiterals.Onboarding.imgFourthTitle
        title.contentMode = .scaleAspectFit
        return title
    }()
    
    private let backButton: UIButton = {
        let backButton = BackButton()
        backButton.isHidden = true
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return backButton
    }()
    
    private let startButton = CustomButton(title: "시작하기", backColor: .donPrimary, titleColor: .donBlack)
    
    private let skipButton = CustomButton(title: "건너뛰기", backColor: .clear, titleColor: .donGray7)
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
    }
    
}

// MARK: - Extensions

extension OnboardingEndingViewController {
    private func setUI() {
        self.view.backgroundColor = .donGray1
    }
    
    private func setHierarchy() {
        self.view.addSubviews(backButton,
                              progressImage,
                              titleImage,
                              startButton,
                              skipButton)
    }
    
    private func setLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(statusBarHeight + 38.adjusted)
            $0.leading.equalToSuperview().inset(23.adjusted)
        }
        
        progressImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(statusBarHeight + 46.adjusted)
            $0.width.equalTo(48.adjusted)
            $0.height.equalTo(6.adjusted)
        }
        
        titleImage.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(91.adjusted)
            $0.top.equalToSuperview().inset(statusBarHeight + 90.adjusted)
            $0.height.equalTo(72.adjusted)
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(91.adjusted)
            $0.centerX.equalToSuperview()
        }
        
        skipButton.snp.makeConstraints {
            $0.top.equalTo(startButton.snp.bottom).offset(12.adjusted)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc 
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
