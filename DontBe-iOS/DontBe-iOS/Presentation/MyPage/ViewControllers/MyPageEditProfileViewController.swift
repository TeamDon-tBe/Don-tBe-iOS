//
//  MyPageEditProfileViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/12/24.
//

import UIKit

class MyPageEditProfileViewController: UIViewController {

    // MARK: - Properties
    
    var isTrue: Bool = true
    
    // MARK: - UI Components
    
    let originView = MyPageEditView()
    
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
    }
}

// MARK: - Extensions

extension MyPageEditProfileViewController {
    private func setUI() {
        tabBarController?.tabBar.isHidden = true
        self.view.backgroundColor = .donGray1
        self.title = StringLiterals.MyPage.MyPageEditNavigationTitle
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
    }
    
    private func setAddTarget() {
        let backButton = UIBarButtonItem.backButton(target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
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
        self.originView.finishActiveButton.isHidden = !isTrue
        
        // 중복확인 -> 성공 (서버통신으로 isTrue 값 변경해주어야함)
        if isTrue {
            self.originView.duplicationCheckDescription.text = StringLiterals.Join.duplicationPass
            self.originView.duplicationCheckDescription.textColor = .donSecondary
        }
        // 중복확인 -> 실패
        else {
            self.originView.duplicationCheckDescription.text = StringLiterals.Join.duplicationNotPass
            self.originView.duplicationCheckDescription.textColor = .donError
        }
    }
}


// MARK: - UITextFieldDelegate

extension MyPageEditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // 키보드 내리면서 동작
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 12 // 글자수 제한
        let oldText = textField.text ?? "" // 입력하기 전 textField에 표시되어있던 text
        let addedText = string // 입력한 text
        let newText = oldText + addedText // 입력하기 전 text와 입력한 후 text를 합침
        let newTextLength = newText.count // 합쳐진 text의 길이
        
        // 글자수 제한
        if newTextLength <= maxLength {
            return true
        }
        
        let lastWordOfOldText = String(oldText[oldText.index(before: oldText.endIndex)]) // 입력하기 전 text의 마지막 글자
        let separatedCharacters = lastWordOfOldText.decomposedStringWithCanonicalMapping.unicodeScalars.map{ String($0) } // 입력하기 전 text의 마지막 글자를 자음과 모음으로 분리
        let separatedCharactersCount = separatedCharacters.count // 분리된 자음, 모음의 개수
        
        if separatedCharactersCount == 1 && !addedText.isConsonant {
            return true
        } else if separatedCharactersCount == 2 && addedText.isConsonant {
            return true
        } else if separatedCharactersCount == 3 && addedText.isConsonant {
            return true
        }
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? "" // textField에 수정이 반영된 후의 text
        let maxLength = 12 // 글자 수 제한
        if text.count >= maxLength {
            let startIndex = text.startIndex
            let endIndex = text.index(startIndex, offsetBy: maxLength - 1)
            let fixedText = String(text[startIndex...endIndex])
            textField.text = fixedText
            self.originView.numOfLetters.text = "12/12"
        } else {
            self.originView.numOfLetters.text = "\(text.count)/12"
        }
    }
}
