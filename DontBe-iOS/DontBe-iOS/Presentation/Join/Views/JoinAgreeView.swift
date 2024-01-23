//
//  JoinAgreeView.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/10/24.
//

import UIKit

import SnapKit

final class JoinAgreeView: UIView {
    
    // MARK: - UI Components
    
    private let topDivisionLine = UIView().makeDivisionLine()
    private let middleDivisionLine = UIView().makeDivisionLine()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = StringLiterals.Join.agreement
        titleLabel.textColor = .donBlack
        titleLabel.font = .font(.head2)
        return titleLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = StringLiterals.Join.checkTerms
        descriptionLabel.textColor = .donGray9
        descriptionLabel.font = .font(.body2)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .left
        descriptionLabel.setTextWithLineHeight(text: descriptionLabel.text, lineHeight: 25.adjusted, alignment: .left)
        return descriptionLabel
    }()
    
    let allCheck = AgreementListCustomView(title: StringLiterals.Join.allCheck, subImage: nil, moreImage: nil)
    let firstCheckView = AgreementListCustomView(title: StringLiterals.Join.useAgreement, subImage: ImageLiterals.Join.imgNecessary)
    let secondCheckView = AgreementListCustomView(title: StringLiterals.Join.privacyAgreement, subImage: ImageLiterals.Join.imgNecessary)
    let thirdCheckView = AgreementListCustomView(title: StringLiterals.Join.checkAge, subImage: ImageLiterals.Join.imgNecessary, moreImage: nil)
    let fourthCheckView = AgreementListCustomView(title: StringLiterals.Join.advertisementAgreement, subImage: ImageLiterals.Join.btnSelect)
    
    private let nextButton: UIButton = {
        let nextButton = CustomButton(title: StringLiterals.Button.next, backColor: .donGray4, titleColor: .donGray9)
        nextButton.isEnabled = false
        return nextButton
    }()
    
    let nextActiveButton: UIButton = {
        let nextActiveButton = CustomButton(title: StringLiterals.Button.next, backColor: .donBlack, titleColor: .donWhite)
        nextActiveButton.isHidden = true
        return nextActiveButton
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

extension JoinAgreeView {
    private func setUI() {
        allCheck.infoLabel.font = .font(.body1)
    }
    
    private func setHierarchy() {
        self.addSubviews(topDivisionLine,
                         titleLabel,
                         descriptionLabel,
                         allCheck,
                         middleDivisionLine,
                         firstCheckView,
                         secondCheckView,
                         thirdCheckView,
                         fourthCheckView,
                         nextButton,
                         nextActiveButton)
    }
    
    private func setLayout() {
        topDivisionLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(1.adjusted)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(54.adjusted)
            $0.leading.equalToSuperview().inset(23.adjusted)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.adjusted)
            $0.leading.equalToSuperview().inset(23.adjusted)
        }
        
        allCheck.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(55.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(28.adjusted)
            $0.height.equalTo(32.adjusted)
        }
        
        middleDivisionLine.snp.makeConstraints {
            $0.top.equalTo(allCheck.snp.bottom).offset(5.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(28.adjusted)
            $0.height.equalTo(1.adjusted)
        }
        
        firstCheckView.snp.makeConstraints {
            $0.top.equalTo(allCheck.snp.bottom).offset(16.adjustedH)
            $0.leading.trailing.height.equalTo(allCheck)
        }
        
        secondCheckView.snp.makeConstraints {
            $0.top.equalTo(firstCheckView.snp.bottom).offset(16.adjustedH)
            $0.leading.trailing.height.equalTo(allCheck)
        }
        
        thirdCheckView.snp.makeConstraints {
            $0.top.equalTo(secondCheckView.snp.bottom).offset(16.adjustedH)
            $0.leading.trailing.height.equalTo(allCheck)
        }
        
        fourthCheckView.snp.makeConstraints {
            $0.top.equalTo(thirdCheckView.snp.bottom).offset(16.adjustedH)
            $0.leading.trailing.height.equalTo(allCheck)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(29.adjusted)
            $0.centerX.equalToSuperview()
        }
        
        nextActiveButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(29.adjusted)
            $0.centerX.equalToSuperview()
        }
    }
}

