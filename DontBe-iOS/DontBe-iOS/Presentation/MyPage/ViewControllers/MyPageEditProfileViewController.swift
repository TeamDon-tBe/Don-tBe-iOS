//
//  MyPageEditProfileViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/12/24.
//

import UIKit

import SnapKit

final class MyPageEditProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    var isTrue: Bool = true

    // MARK: - UI Components
    
    let originView = MyPageNicknameEditView()
    let editView = MyPageIntroductionEditView()
    
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
}

// MARK: - Extensions

extension MyPageEditProfileViewController {
    private func setUI() {
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        self.view.backgroundColor = .donGray1
        self.title = StringLiterals.MyPage.MyPageEditNavigationTitle
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
    }
    
    private func setHierarchy() {
        self.view.addSubviews(originView,
                              editView)
    }
    
    private func setLayout() {
        originView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(323.adjusted)
        }
        
        editView.snp.makeConstraints {
            $0.top.equalTo(originView.duplicationCheckDescription.snp.bottom).offset(16.adjustedH)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setAddTarget() {
        let backButton = UIBarButtonItem.backButton(target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTisEmpty), name: UITextField.textDidChangeNotification, object: nil)
        
        originView.duplicationCheckButton.addTarget(self, action: #selector(duplicationCheckButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func duplicationCheckButtonTapped() {
        // 중복확인 서버통신에 성공
        self.originView.nickNameTextField.resignFirstResponder()
        self.editView.postButton.isEnabled = !isTrue
        
        // 중복확인 -> 성공 (서버통신으로 isTrue 값 변경해주어야함)
        if isTrue {
            self.originView.duplicationCheckDescription.text = StringLiterals.Join.duplicationPass
            self.editView.postButton.setTitleColor(.donWhite, for: .normal)
            self.editView.postButton.backgroundColor = .donBlack
            self.originView.duplicationCheckDescription.textColor = .donSecondary
        }
        // 중복확인 -> 실패
        else {
            self.originView.duplicationCheckDescription.text = StringLiterals.Join.duplicationNotPass
            self.editView.postButton.setTitleColor(.donGray9, for: .normal)
            self.editView.postButton.backgroundColor = .donGray4
            self.originView.duplicationCheckDescription.textColor = .donError
        }
    }
    
    @objc
    private func textFieldTisEmpty() {
        print("dsafadsfdsafdsafadsf")
        self.editView.postButton.setTitleColor(.donGray9, for: .normal)
        self.editView.postButton.backgroundColor = .donGray4
        self.editView.postButton.isEnabled = false
    }
}
