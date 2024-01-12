//
//  OnboardingViewController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/9/24.
//

import UIKit

import SnapKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - Properties

    static var pushCount: Int = 0
    private let dummy = OnboardingDummy.dummy()
    
    // MARK: - UI Components
    
    private let progressImage: UIImageView = {
        let progress = UIImageView()
        progress.image = ImageLiterals.Onboarding.progressbar1
        return progress
    }()
    
    private let titleImage: UIImageView = {
        let title = UIImageView()
        title.image = ImageLiterals.Onboarding.imgOneTitle
        title.contentMode = .scaleAspectFit
        return title
    }()
    
    private let mainImage: UIImageView = {
        let mainImage = UIImageView()
        mainImage.image = ImageLiterals.Onboarding.imgOne
        mainImage.contentMode = .scaleAspectFit
        return mainImage
    }()
    
    private let backButton: UIButton = {
        let backButton = BackButton()
        backButton.isHidden = true
        return backButton
    }()
    
    private let nextButton: UIButton = {
        let nextButton = CustomButton(title: StringLiterals.Button.next, backColor: .donBlack, titleColor: .donWhite)
        return nextButton
    }()
    
    private let skipButton = CustomButton(title: StringLiterals.Button.skip, backColor: .clear, titleColor: .donGray7)
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
    }
    
}

// MARK: - Extensions

extension OnboardingViewController {
    private func setUI() {
        self.view.backgroundColor = .donGray1
    }
    
    private func setHierarchy() {
        self.view.addSubviews(backButton,
                              progressImage,
                              titleImage,
                              mainImage,
                              nextButton,
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
        
        if loadUserData()?.isSocialLogined == true {
            nextButton.snp.makeConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(91.adjusted)
                $0.centerX.equalToSuperview()
            }
            
            skipButton.snp.makeConstraints {
                $0.top.equalTo(nextButton.snp.bottom).offset(12.adjusted)
                $0.centerX.equalToSuperview()
            }
        } else {
            nextButton.snp.makeConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(29.adjusted)
                $0.centerX.equalToSuperview()
            }
        }
    }
    
    private func setAddTarget() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func setOnboardingView(viewController: OnboardingViewController) {
        viewController.backButton.isHidden = false
        viewController.progressImage.image = self.dummy[OnboardingViewController.pushCount].progress
        viewController.titleImage.image = self.dummy[OnboardingViewController.pushCount].titleImage
        viewController.mainImage.image = self.dummy[OnboardingViewController.pushCount].mainImage
    }
    
    @objc 
    private func nextButtonTapped() {
        OnboardingViewController.pushCount += 1
        if OnboardingViewController.pushCount < 3 {
            let viewController = OnboardingViewController()
            self.setOnboardingView(viewController: viewController)
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = OnboardingEndingViewController(viewModel: OnboardingEndingViewModel())
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc
    private func backButtonTapped() {
        OnboardingViewController.pushCount -= 1
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func skipButtonTapped() {
        let viewController = OnboardingEndingViewController(viewModel: OnboardingEndingViewModel())
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
