//
//  ProfileView.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/11/24.
//

import UIKit

import SnapKit

final class JoinProfileView: UIView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let topDivisionLine = UIView().makeDivisionLine()

    let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.setCircularImage(image: ImageLiterals.Common.imgProfile)
        return profileImage
    }()
    
    // 2차 스프린트
//    let plusButton: UIButton = {
//        let plusButton = UIButton()
//        plusButton.setImage(ImageLiterals.Join.btnPlus, for: .normal)
//        return plusButton
//    }()
    
    private let nickNameLabel: UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.text = StringLiterals.Join.nickName
        nickNameLabel.textColor = .donBlack
        nickNameLabel.font = .font(.body1)
        return nickNameLabel
    }()
    
    let nickNameTextField: UITextField = {
        let nickNameTextField = UITextField()
        nickNameTextField.placeholder = StringLiterals.Join.nickNamePlaceHolder
        nickNameTextField.textAlignment = .left
        nickNameTextField.textColor = .donBlack
        nickNameTextField.font = .font(.body4)
        nickNameTextField.backgroundColor = .donGray2
        nickNameTextField.layer.cornerRadius = 4.adjusted
        nickNameTextField.setPlaceholderColor(.donGray7)
        nickNameTextField.setLeftPaddingPoints(14.adjusted)
        nickNameTextField.setRightPaddingPoints(14.adjusted)
        return nickNameTextField
    }()
    
    let numOfLetters: UILabel = {
        let label = UILabel()
        label.text = "(0/12)"
        label.textColor = .donGray7
        label.font = .font(.caption4)
        return label
    }()
    
    let duplicationCheckButton: UIButton = {
        let duplicationCheckButton = UIButton()
        duplicationCheckButton.setTitle(StringLiterals.Join.duplicationCheck, for: .normal)
        duplicationCheckButton.setTitleColor(.donGray9, for: .normal)
        duplicationCheckButton.backgroundColor = .donGray4
        duplicationCheckButton.titleLabel?.font = .font(.body3)
        duplicationCheckButton.layer.cornerRadius = 4.adjusted
        duplicationCheckButton.layer.masksToBounds = true
        duplicationCheckButton.isEnabled = false
        return duplicationCheckButton
    }()
    
    let duplicationCheckDescription: UILabel = {
        let duplicationCheckDescription = UILabel()
        duplicationCheckDescription.text = StringLiterals.Join.duplicationCheckDescription
        duplicationCheckDescription.textColor = .donGray8
        duplicationCheckDescription.font = .font(.caption4)
        return duplicationCheckDescription
    }()
    
    let isNotValidNickname: UILabel = {
        let isNotValidNickname = UILabel()
        isNotValidNickname.text = StringLiterals.Join.notValidNickName
        isNotValidNickname.textColor = .donError
        isNotValidNickname.font = .font(.caption4)
        isNotValidNickname.isHidden = true
        return isNotValidNickname
    }()
    
    let finishButton: UIButton = {
        let finishButton = CustomButton(title: StringLiterals.Button.finish, backColor: .donGray4, titleColor: .donGray9)
        finishButton.isEnabled = false
        return finishButton
    }()
    
    let finishActiveButton: UIButton = {
        let finishActiveButton = CustomButton(title: StringLiterals.Button.finish, backColor: .donBlack, titleColor: .donWhite)
        finishActiveButton.isHidden = true
        return finishActiveButton
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setDelegate()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension JoinProfileView {
    private func setHierarchy() {
        self.addSubviews(topDivisionLine,
                         profileImage,
//                         plusButton,
                         nickNameLabel,
                         nickNameTextField,
                         duplicationCheckButton,
                         duplicationCheckDescription,
                         isNotValidNickname,
                         finishButton,
                         finishActiveButton)
        
        nickNameTextField.addSubview(numOfLetters)
    }
    
    private func setLayout() {
        topDivisionLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(1.adjusted)
        }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(52.adjustedH)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100.adjusted)
        }
        
//        plusButton.snp.makeConstraints {
//            $0.top.equalTo(profileImage).offset(72.adjusted)
//            $0.leading.equalTo(profileImage).offset(78.adjusted)
//            $0.size.equalTo(34.adjusted)
//        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(171.adjustedH)
            $0.leading.equalToSuperview().inset(16.adjusted)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(10.adjustedH)
            $0.leading.equalToSuperview().inset(16.adjusted)
            $0.trailing.equalToSuperview().inset(107.adjusted)
            $0.height.equalTo(44.adjusted)
        }
        
        numOfLetters.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(14.adjusted)
            $0.centerY.equalToSuperview()
        }
        
        duplicationCheckButton.snp.makeConstraints {
            $0.centerY.height.equalTo(nickNameTextField)
            $0.leading.equalTo(nickNameTextField.snp.trailing).offset(6.adjusted)
            $0.trailing.equalToSuperview().inset(16.adjusted)
        }
        
        duplicationCheckDescription.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(6.adjustedH)
            $0.leading.equalToSuperview().inset(16.adjusted)
        }
        
        isNotValidNickname.snp.makeConstraints {
            $0.top.leading.equalTo(duplicationCheckDescription)
        }
        
        finishButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(29.adjusted)
            $0.centerX.equalToSuperview()
        }
        
        finishActiveButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(29.adjusted)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        self.nickNameTextField.delegate = self
    }
}

// MARK: - UITextFieldDelegate

extension JoinProfileView: UITextFieldDelegate {
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
            self.numOfLetters.text = "(\(maxLength)/\(maxLength))"
        } else {
            self.numOfLetters.text = "(\(text.count)/\(maxLength))"
        }

        if isValidInput(text) {
            duplicationCheckButton.isEnabled = true
            duplicationCheckButton.setTitleColor(.donBlack, for: .normal)
            duplicationCheckButton.backgroundColor = .donPrimary
        } else {
            duplicationCheckButton.isEnabled = false
            duplicationCheckButton.setTitleColor(.donGray9, for: .normal)
            duplicationCheckButton.backgroundColor = .donGray4
        }
        
        duplicationCheckDescription.isHidden = !isValidInput(text)
        isNotValidNickname.isHidden = isValidInput(text)
    }
}
