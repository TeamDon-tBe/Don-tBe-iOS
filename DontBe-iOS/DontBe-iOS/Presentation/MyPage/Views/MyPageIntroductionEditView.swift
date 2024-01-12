//
//  MyPageEditTextView.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/13/24.
//

import UIKit

import SnapKit

final class MyPageIntroductionEditView: UIView {

    // MARK: - Properties
    
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy) // 햅틱 기능
    let maxLength = 50 // 최대 글자 수
    
    // MARK: - UI Components

    private let introduction: UILabel = {
        let introduction = UILabel()
        introduction.text = StringLiterals.MyPage.myPageEditIntroduction
        introduction.textColor = .donBlack
        introduction.font = .font(.body1)
        return introduction
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.font(.body4)
        textView.textColor = .donGray12
        textView.tintColor = .donPrimary
        textView.backgroundColor = .donGray2
        textView.textContainerInset = UIEdgeInsets(top: 14.adjusted, left: 14.adjusted, bottom: 14.adjusted, right: 14.adjusted)
        textView.addPlaceholder(StringLiterals.MyPage.myPageEditIntroductionPlease, padding: UIEdgeInsets(top: 14.adjusted, left: 14.adjusted, bottom: 14.adjusted, right: 14.adjusted))
        textView.layer.cornerRadius = 4.adjusted
        textView.layer.masksToBounds = true
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainer.maximumNumberOfLines = 0
        return textView
    }()
    
    private let numOfLetters: UILabel = {
        let numOfLetters = UILabel()
        numOfLetters.text = "0/50"
        numOfLetters.textColor = .donGray7
        numOfLetters.font = .font(.caption4)
        return numOfLetters
    }()
    
    let postButton: UIButton = {
        let button = UIButton()
        button.setTitle(StringLiterals.Button.editFinish, for: .normal)
        button.setTitleColor(.donGray9, for: .normal)
        button.titleLabel?.font = UIFont.font(.body3)
        button.backgroundColor = .donGray4
        button.layer.cornerRadius = 4.adjusted
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setDelegate()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension MyPageIntroductionEditView {
    func setDelegate() {
        self.contentTextView.delegate = self
    }
    
    func setHierarchy() {
        self.addSubviews(introduction,
                         contentTextView,
                         numOfLetters,
                         postButton)
    }
    
    func setLayout() {
        introduction.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5.adjusted)
            $0.leading.equalToSuperview().inset(16.adjusted)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(introduction.snp.bottom).offset(6.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(16.adjusted)
            $0.height.equalTo(120.adjusted)
        }
        
        numOfLetters.snp.makeConstraints {
            $0.trailing.equalTo(contentTextView).inset(14.adjusted)
            $0.bottom.equalTo(contentTextView).inset(12.adjusted)
        }
    
        postButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(342.adjusted)
            $0.height.equalTo(50.adjusted)
            $0.bottom.equalToSuperview().inset(29.adjusted)
        }
    }
}

extension MyPageIntroductionEditView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let textLength = contentTextView.text.count
        textView.text = String(textView.text.prefix(maxLength))
        
        postButton.setTitleColor(.donWhite, for: .normal)
        postButton.backgroundColor = .donBlack
        postButton.isEnabled = true
        
        if textLength == 0 {
            postButton.setTitleColor(.donGray9, for: .normal)
            postButton.backgroundColor = .donGray4
            postButton.isEnabled = false
        } else if textLength < 50 {
            self.numOfLetters.text = "\(textLength)/50"
        } else {
            self.numOfLetters.text = "50/50"
        }
    }
}
