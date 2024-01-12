//
//  OnboardingView.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/13/24.
//

import UIKit

import SnapKit

final class OnboardingView: UIView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    let progressImage: UIImageView = {
        let progress = UIImageView()
        progress.image = ImageLiterals.Onboarding.progressbar1
        return progress
    }()
    
    let titleImage: UIImageView = {
        let title = UIImageView()
        title.image = ImageLiterals.Onboarding.imgOneTitle
        title.contentMode = .scaleAspectFit
        return title
    }()
    
    let mainImage: UIImageView = {
        let mainImage = UIImageView()
        mainImage.image = ImageLiterals.Onboarding.imgOne
        mainImage.contentMode = .scaleAspectFit
        return mainImage
    }()
    
    let backButton: UIButton = {
        let backButton = BackButton()
        backButton.isHidden = true
        return backButton
    }()
    
    let nextButton: UIButton = {
        let nextButton = CustomButton(title: StringLiterals.Button.next, backColor: .donBlack, titleColor: .donWhite)
        return nextButton
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

extension OnboardingView {
    private func setHierarchy() {
        self.addSubviews(backButton,
                        progressImage,
                        titleImage,
                        mainImage,
                        nextButton,
                        skipButton)
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
        
        if OnboardingViewController.pushCount == 0 {
            titleImage.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(91.adjusted)
                $0.top.equalToSuperview().inset(statusBarHeight + 90.adjustedH)
                $0.height.equalTo(72.adjusted)
            }
            
            mainImage.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalTo(360.adjusted)
                $0.height.equalTo(340.adjusted)
            }
        } else if OnboardingViewController.pushCount == 1 {
            titleImage.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(80.adjusted)
                $0.top.equalToSuperview().inset(statusBarHeight + 83.adjustedH)
                $0.height.equalTo(102.adjusted)
            }
            
            mainImage.snp.makeConstraints {
                $0.centerY.equalToSuperview().offset(38.adjusted)
                $0.width.equalToSuperview()
                $0.height.equalTo(230.adjusted)
            }
        } else {
            titleImage.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(49.adjusted)
                $0.top.equalToSuperview().inset(statusBarHeight + 90.adjustedH)
                $0.height.equalTo(72.adjusted)
            }
            
            mainImage.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().offset(31.adjusted)
                $0.width.equalTo(336.adjusted)
                $0.height.equalTo(238.adjusted)
            }
        }
        
        DispatchQueue.main.async {
            if loadUserData()?.isNotFirstUser == true {
                self.nextButton.snp.makeConstraints {
                    $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(91.adjusted)
                    $0.centerX.equalToSuperview()
                }
                
                self.skipButton.snp.makeConstraints {
                    $0.top.equalTo(self.nextButton.snp.bottom).offset(12.adjusted)
                    $0.centerX.equalToSuperview()
                }
            } else {
                self.nextButton.snp.makeConstraints {
                    $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(29.adjusted)
                    $0.centerX.equalToSuperview()
                }
            }
        }
    }
}
