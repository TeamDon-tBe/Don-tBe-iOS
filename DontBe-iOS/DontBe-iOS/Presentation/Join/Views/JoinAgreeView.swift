//
//  JoinAgreeView.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/10/24.
//

import UIKit

import SnapKit

final class JoinAgreeView: UIView {

    // MARK: - Properties
    
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
        descriptionLabel.setTextWithLineHeight(text: descriptionLabel.text, lineHeight: 25.adjusted)
        return descriptionLabel
    }()
    
    private let allCheck = CustomView(title: StringLiterals.Join.allCheck, subImage: nil, moreImage: nil)
    
    private let firstCheckView = CustomView(title: StringLiterals.Join.useAgreement, subImage: ImageLiterals.Join.btnNecessary)
    private let secondCheckView = CustomView(title: StringLiterals.Join.privacyAgreement, subImage: ImageLiterals.Join.btnNecessary)
    private let thirdCheckView = CustomView(title: StringLiterals.Join.checkAge, subImage: ImageLiterals.Join.btnNecessary)
    private let fourthCheckView = CustomView(title: StringLiterals.Join.advertisementAgreement, subImage: ImageLiterals.Join.btnSelect)
    
    private let nextButton: UIButton = {
        let nextButton = CustomButton(title: StringLiterals.Button.next, backColor: .donGray4, titleColor: .donGray9)
        return nextButton
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
    func setUI() {
        
    }
    
    func setHierarchy() {
        self.addSubviews(topDivisionLine,
                              titleLabel,
                              descriptionLabel,
                              allCheck,
                              middleDivisionLine,
                              firstCheckView,
                              secondCheckView,
                              thirdCheckView,
                              fourthCheckView,
                              nextButton)
    }
    
    func setLayout() {
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
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(55.adjusted)
            $0.leading.trailing.equalToSuperview().inset(32.adjusted)
            $0.height.equalTo(24.adjusted)
        }
        
        middleDivisionLine.snp.makeConstraints {
            $0.top.equalTo(allCheck.snp.bottom).offset(9.adjusted)
            $0.leading.trailing.equalToSuperview().inset(28.adjusted)
            $0.height.equalTo(1.adjusted)
        }
        
        firstCheckView.snp.makeConstraints {
            $0.top.equalTo(allCheck.snp.bottom).offset(24.adjusted)
            $0.leading.trailing.height.equalTo(allCheck)
        }
        
        secondCheckView.snp.makeConstraints {
            $0.top.equalTo(firstCheckView.snp.bottom).offset(24.adjusted)
            $0.leading.trailing.height.equalTo(allCheck)
        }
        
        thirdCheckView.snp.makeConstraints {
            $0.top.equalTo(secondCheckView.snp.bottom).offset(24.adjusted)
            $0.leading.trailing.height.equalTo(allCheck)
        }
        
        fourthCheckView.snp.makeConstraints {
            $0.top.equalTo(thirdCheckView.snp.bottom).offset(24.adjusted)
            $0.leading.trailing.height.equalTo(allCheck)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(29.adjusted)
            $0.centerX.equalToSuperview()
        }
    }
}

