//
//  MyPageEditView.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/13/24.
//

import UIKit

import SnapKit

final class MyPageEditView: UIView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let topDivisionLine = UIView().makeDivisionLine()

    let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.setCircularImage(image: ImageLiterals.Common.imgProfile)
        return profileImage
    }()
    
    let plusButton: UIButton = {
        let plusButton = UIButton()
        plusButton.setImage(ImageLiterals.Join.btnPlus, for: .normal)
        return plusButton
    }()
    
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
        duplicationCheckButton.setTitleColor(.donBlack, for: .normal)
        duplicationCheckButton.titleLabel?.font = .font(.body3)
        duplicationCheckButton.layer.cornerRadius = 4.adjusted
        duplicationCheckButton.layer.masksToBounds = true
        duplicationCheckButton.backgroundColor = .donPrimary
        return duplicationCheckButton
    }()
    
    let duplicationCheckDescription: UILabel = {
        let duplicationCheckDescription = UILabel()
        duplicationCheckDescription.text = StringLiterals.Join.duplicationCheckDescription
        duplicationCheckDescription.textColor = .donGray8
        duplicationCheckDescription.font = .font(.caption4)
        return duplicationCheckDescription
    }()
    
    let finishButton: UIButton = {
        let finishButton = CustomButton(title: StringLiterals.Button.finish, backColor: .donGray4, titleColor: .donGray9)
        finishButton.isEnabled = false
        return finishButton
    }()
    
    let finishActiveButton: UIButton = {
        let finishActiveButton = CustomButton(title: StringLiterals.Button.editFinish, backColor: .donBlack, titleColor: .donWhite)
        finishActiveButton.isHidden = true
        return finishActiveButton
    }()
    
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

extension MyPageEditView {
    func setHierarchy() {
        self.addSubviews(topDivisionLine,
                         profileImage,
                         plusButton,
                         nickNameLabel,
                         nickNameTextField,
                         duplicationCheckButton,
                         duplicationCheckDescription,
                         finishButton,
                         finishActiveButton)
        
        nickNameTextField.addSubview(numOfLetters)
    }
    
    func setLayout() {
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
        
        plusButton.snp.makeConstraints {
            $0.top.equalTo(profileImage).offset(72.adjusted)
            $0.leading.equalTo(profileImage).offset(78.adjusted)
            $0.size.equalTo(34.adjusted)
        }
        
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
        
        finishButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(29.adjusted)
            $0.centerX.equalToSuperview()
        }
        
        finishActiveButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(29.adjusted)
            $0.centerX.equalToSuperview()
        }
    }
}
