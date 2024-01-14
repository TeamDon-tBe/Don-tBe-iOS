//
//  MyPageEditProfileViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/12/24.
//

import UIKit

import SnapKit

final class MyPageEditProfileViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    var isTrue: Bool = true

    // MARK: - UI Components
    
    let nicknameEditView = MyPageNicknameEditView()
    let introductionEditView = MyPageIntroductionEditView()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
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
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

// MARK: - Extensions

extension MyPageEditProfileViewController {
    private func setUI() {
        self.view.backgroundColor = .donWhite
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        self.title = StringLiterals.MyPage.MyPageEditNavigationTitle
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func setHierarchy() {
        self.view.addSubviews(nicknameEditView,
                              introductionEditView)
    }
    
    private func setLayout() {
        nicknameEditView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(323.adjusted)
        }
        
        introductionEditView.snp.makeConstraints {
            $0.top.equalTo(nicknameEditView.duplicationCheckDescription.snp.bottom).offset(16.adjustedH)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setAddTarget() {
        let backButton = UIBarButtonItem.backButton(target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTisEmpty), name: UITextField.textDidChangeNotification, object: nil)
        
        nicknameEditView.duplicationCheckButton.addTarget(self, action: #selector(duplicationCheckButtonTapped), for: .touchUpInside)
        introductionEditView.postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func duplicationCheckButtonTapped() {
        // 중복확인 서버통신에 성공
        self.nicknameEditView.nickNameTextField.resignFirstResponder()
        self.introductionEditView.postButton.isEnabled = !isTrue
        
        // 중복확인 -> 성공 (서버통신으로 isTrue 값 변경해주어야함)
        if isTrue {
            self.nicknameEditView.duplicationCheckDescription.text = StringLiterals.Join.duplicationPass
            self.introductionEditView.postButton.setTitleColor(.donWhite, for: .normal)
            self.introductionEditView.postButton.backgroundColor = .donBlack
            self.nicknameEditView.duplicationCheckDescription.textColor = .donSecondary
        }
        // 중복확인 -> 실패
        else {
            self.nicknameEditView.duplicationCheckDescription.text = StringLiterals.Join.duplicationNotPass
            self.introductionEditView.postButton.setTitleColor(.donGray9, for: .normal)
            self.introductionEditView.postButton.backgroundColor = .donGray4
            self.nicknameEditView.duplicationCheckDescription.textColor = .donError
        }
    }
    
    @objc
    private func postButtonTapped() {
        // 서버통신 -> POST
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func textFieldTisEmpty() {
        self.introductionEditView.postButton.setTitleColor(.donGray9, for: .normal)
        self.introductionEditView.postButton.backgroundColor = .donGray4
        self.introductionEditView.postButton.isEnabled = false
    }
}
