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
    
    // MARK: - UI Components
        
    let nextButton = CustomButton(title: "다음으로")
    
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

extension OnboardingViewController {
    func setUI() {
        self.view.backgroundColor = .donGray1
    }
    
    func setHierarchy() {
        self.view.addSubviews(nextButton)
    }
    
    func setLayout() {
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(91.adjusted)
            $0.leading.trailing.equalToSuperview().inset(17.adjusted)
            $0.height.equalTo(50.adjusted)
        }
    }
    
}
