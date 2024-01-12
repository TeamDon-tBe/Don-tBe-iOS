//
//  OnboardingEndingView.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/12/24.
//

import UIKit

import SnapKit

final class OnboardingEndingView: UIView {

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
    
    private let profileImage: UIImageView = {
        let profile = UIImageView()
        profile.image = ImageLiterals.Common.imgProfile
        return profile
    }()

    let introductionView = IntroductionView()
    
    let backButton = BackButton()
    
    let startButton: UIButton = {
        let startButton = UIButton()
        startButton.setTitle(StringLiterals.Button.start, for: .normal)
        startButton.titleLabel?.font = .font(.body3)
        startButton.backgroundColor = .donGray4
        startButton.setTitleColor(.donGray9, for: .normal)
        startButton.layer.cornerRadius = 6.adjusted
        startButton.isEnabled = false
        return startButton
    }()
    
    let skipButton = CustomButton(title: StringLiterals.Button.skip, backColor: .clear, titleColor: .donGray7)
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension OnboardingEndingView {
    private func setHierarchy() {
        self.addSubviews(backButton,
                              progressImage,
                              titleImage,
                              profileImage,
                              introductionView,
                              startButton,
                              skipButton)
        self.bringSubviewToFront(profileImage)
    }
    
    private func setLayout() {
        let statusBarHeight = UIApplication.shared.connectedScenes
                   .compactMap { $0 as? UIWindowScene }
                   .first?
                   .statusBarManager?
                   .statusBarFrame.height ?? 20
        
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
            $0.top.equalToSuperview().inset(statusBarHeight + 90.adjustedH)
            $0.height.equalTo(72.adjusted)
        }
        
        profileImage.snp.makeConstraints {
            $0.size.equalTo(100.adjusted)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(statusBarHeight + 186.adjustedH)
        }
        
        introductionView.snp.makeConstraints {
            $0.width.equalTo(320.adjusted)
            $0.height.equalTo(229.adjusted)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImage).offset(50.adjusted)
        }
        
        if loadUserData()?.isSocialLogined == true {
            startButton.snp.makeConstraints {
                $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(91.adjusted)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(342.adjusted)
                $0.height.equalTo(50.adjusted)
            }
            
            skipButton.snp.makeConstraints {
                $0.top.equalTo(startButton.snp.bottom).offset(12.adjusted)
                $0.centerX.equalToSuperview()
            }
        } else {
            startButton.snp.makeConstraints {
                $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(29.adjusted)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(342.adjusted)
                $0.height.equalTo(50.adjusted)
            }
        }
    }
}

