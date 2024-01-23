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
    
    let originView = OnboardingView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = originView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
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
    
    private func setAddTarget() {
        self.originView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        self.originView.skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        self.originView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func setOnboardingView(viewController: OnboardingViewController) {
        viewController.originView.backButton.isHidden = false
        viewController.originView.progressImage.image = self.dummy[OnboardingViewController.pushCount].progress
        viewController.originView.titleImage.image = self.dummy[OnboardingViewController.pushCount].titleImage
        viewController.originView.mainImage.image = self.dummy[OnboardingViewController.pushCount].mainImage
    }
    
    @objc 
    private func nextButtonTapped() {
        OnboardingViewController.pushCount += 1
        if OnboardingViewController.pushCount < 3 {
            let viewController = OnboardingViewController()
            viewController.originView.isFirstUser = self.originView.isFirstUser
            self.setOnboardingView(viewController: viewController)
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = OnboardingEndingViewController(viewModel: OnboardingEndingViewModel(networkProvider: NetworkService()))
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
        let viewController = OnboardingEndingViewController(viewModel: OnboardingEndingViewModel(networkProvider: NetworkService()))
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
