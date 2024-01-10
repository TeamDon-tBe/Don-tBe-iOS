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
    
    let nickNameLabel: UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.text = StringLiterals.Join.nickName
        nickNameLabel.textColor = .donBlack
        nickNameLabel.font = .font(.body1)
        return nickNameLabel
    }()
    
    let nickNameTextField: UITextField = {
        let nickNameTextField = UITextField()
        nickNameTextField.placeholder = StringLiterals.Join.nickNamePlaceHolder
        nickNameTextField.textAlignment = .center
        nickNameTextField.textColor = .donGray7
        nickNameTextField.font = .font(.body4)
        nickNameTextField.backgroundColor = .donGray2
        nickNameTextField.layer.cornerRadius = 4.adjusted
        nickNameTextField.setPlaceholderColor(.donGray7)
        nickNameTextField.setLeftPaddingPoints(14.adjusted)
        nickNameTextField.setRightPaddingPoints(14.adjusted)
        return nickNameTextField
    }()
    
    let duplicationCheckButton: UIButton = {
        let duplicationCheckButton = UIButton()
        duplicationCheckButton.setTitle(StringLiterals.Join.duplicationCheck, for: .normal)
        duplicationCheckButton.setTitleColor(.donBlack, for: .normal)
        duplicationCheckButton.titleLabel?.font = .font(.body3)
        duplicationCheckButton.layer.cornerRadius = 4.adjusted
        duplicationCheckButton.layer.masksToBounds = true
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
    
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension JoinProfileView {
    func setUI() {
        self.backgroundColor = .donWhite
    }
    
    func setHierarchy() {
        self.addSubviews(profileImage,
                         plusButton,
                         nickNameLabel,
                         nickNameTextField,
                         duplicationCheckButton,
                         duplicationCheckDescription,
                         finishButton)
    }
    
    func setLayout() {
        profileImage.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(52.adjusted)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100.adjusted)
        }
        
        plusButton.snp.makeConstraints {
            $0.top.equalTo(profileImage).offset(72.adjusted)
            $0.leading.equalTo(profileImage).offset(78.adjusted)
            $0.size.equalTo(34.adjusted)
        }
        
        finishButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(29.adjusted)
            $0.centerX.equalToSuperview()
        }
    }
}
