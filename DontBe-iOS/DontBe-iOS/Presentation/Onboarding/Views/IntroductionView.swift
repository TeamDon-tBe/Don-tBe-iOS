//
//  OnboardingEndingView.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/10/24.
//

import UIKit

import SnapKit

final class IntroductionView: UIView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let nickName: UILabel = {
        let nickName = UILabel()
        nickName.text = loadUserData()?.userNickname
        nickName.textColor = .donBlack
        nickName.font = .font(.head3)
        return nickName
    }()
    
    let introduction: UITextField = {
        let textField = UITextField()
        textField.placeholder = StringLiterals.Onboarding.placeHolder
        textField.textAlignment = .center
        textField.textColor = .donGray10
        textField.font = .font(.body4)
        textField.backgroundColor = .donGray1
        textField.layer.cornerRadius = 6.adjusted
        textField.setPlaceholderColor(.donGray10)
        textField.setLeftPaddingPoints(12.adjusted)
        textField.setRightPaddingPoints(12.adjusted)
        return textField
    }()
    
    private let information: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.Onboarding.information
        label.numberOfLines = 2
        label.textColor = .donGray8
        label.font = .font(.caption4)
        label.setTextWithLineHeight(text: label.text, lineHeight: 17.adjusted, alignment: .center)
        return label
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

extension IntroductionView {
    func setUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 6.adjusted
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.donGray3.cgColor
        self.layer.borderWidth = 1
    }
    
    func setHierarchy() {
        self.addSubviews(nickName,
                         introduction,
                         information)
    }
    
    func setLayout() {
        nickName.snp.makeConstraints {
            $0.top.equalToSuperview().inset(63.adjusted)
            $0.centerX.equalToSuperview()
        }
        
        introduction.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(70.adjusted)
            $0.leading.trailing.equalToSuperview().inset(16.adjusted)
            $0.height.equalTo(55.adjusted)
        }
        
        information.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(22.adjusted)
            $0.height.equalTo(36.adjusted)
        }
    }
}


