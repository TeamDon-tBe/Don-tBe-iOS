//
//  WriteTextView.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/8/24.
//

import UIKit

import SnapKit

final class WriteTextView: UIView {

    // MARK: - Properties
    
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy) // 햅틱 기능
    let maxLength = 500 // 최대 글자 수
    
    // MARK: - UI Components
    
    let userProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.load(url: loadUserData()?.userProfileImage ?? StringLiterals.Network.baseImageURL)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        return imageView
    }()
    
    let userNickname: UILabel = {
        let label = UILabel()
        label.text = loadUserData()?.userNickname ?? ""
        label.font = UIFont.font(.body3)
        label.textColor = .donBlack
        return label
    }()
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.font(.body4)
        textView.textColor = .donBlack
        textView.tintColor = .donPrimary
        textView.backgroundColor = .clear
        textView.addPlaceholder(StringLiterals.Write.writeContentPlaceholder, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainer.maximumNumberOfLines = 0
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    
    private let keyboardToolbarView: UIView = {
        let view = UIView()
        view.backgroundColor = .donWhite
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.donGray2.cgColor
        return view
    }()
    
    private let circleProgressBar: CircleProgressbar = {
        let circle = CircleProgressbar()
        circle.backgroundColor = .clear
        circle.circleTintColor = .donPrimary
        circle.circleBackgroundColor = .donGray3
        return circle
    }()
    
    private let limitedCircleProgressBar: CircleProgressbar = {
        let circle = CircleProgressbar()
        circle.backgroundColor = .clear
        circle.value = 1.0
        circle.circleTintColor = .donError
        circle.circleBackgroundColor = .donError
        return circle
    }()
    
    public let postButton: UIButton = {
        let button = UIButton()
        button.setTitle(StringLiterals.Write.writePostButtonTitle, for: .normal)
        button.setTitleColor(.donGray9, for: .normal)
        button.titleLabel?.font = UIFont.font(.body3)
        button.backgroundColor = .donGray3
        button.layer.cornerRadius = 4.adjusted
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setDelegate()
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

extension WriteTextView {
    func setDelegate() {
        self.contentTextView.delegate = self
    }
    
    func setUI() {
        limitedCircleProgressBar.alpha = 0
                
        if UserDefaults.standard.integer(forKey: "memberGhost") > -85 {
            contentTextView.becomeFirstResponder()
        }
        // 햅틱 피드백 생성
        impactFeedbackGenerator.prepare()
    }
    
    func setHierarchy() {
        self.addSubviews(userProfileImage, 
                         userNickname,
                         contentTextView,
                         keyboardToolbarView)
        
        keyboardToolbarView.addSubviews(circleProgressBar,
                                        limitedCircleProgressBar,
                                        postButton)
    }
    
    func setLayout() {
        userProfileImage.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(12.adjusted)
            $0.leading.equalToSuperview().inset(16.adjusted)
            $0.width.equalTo(44.adjusted)
            $0.height.equalTo(44.adjusted)
        }
        
        userNickname.snp.makeConstraints {
            $0.top.equalTo(userProfileImage.snp.top).offset(1.adjusted)
            $0.leading.equalTo(userProfileImage.snp.trailing).offset(11.adjusted)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(userNickname.snp.bottom).offset(4.adjusted)
            $0.leading.equalTo(userNickname.snp.leading)
            $0.trailing.equalToSuperview().inset(16.adjusted)
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top)
        }
        
        keyboardToolbarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56.adjusted)
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top)
        }
        
        circleProgressBar.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(84.adjusted)
            $0.width.height.equalTo(20.adjusted)
        }
        
        limitedCircleProgressBar.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(84.adjusted)
            $0.width.height.equalTo(20.adjusted)
        }
        
        postButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16.adjusted)
            $0.width.equalTo(60.adjusted)
            $0.height.equalTo(36.adjusted)
        }
    }
}

extension WriteTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let textLength = contentTextView.text.count
        textView.text = String(textView.text.prefix(maxLength))
        if textLength == 0 {
            let value = Double(textLength) / 500
            circleProgressBar.value = value
            postButton.setTitleColor(.donGray9, for: .normal)
            postButton.backgroundColor = .donGray3
            postButton.isEnabled = false
        } else {
            postButton.setTitleColor(.donBlack, for: .normal)
            postButton.backgroundColor = .donPrimary
            postButton.isEnabled = true
            
            if textLength < 500 {
                limitedCircleProgressBar.alpha = 0
                circleProgressBar.alpha = 1
                
                let value = Double(textLength) / 500
                circleProgressBar.value = value
                postButton.isEnabled = true
                postButton.backgroundColor = .donPrimary
            } else {
                limitedCircleProgressBar.alpha = 1
                circleProgressBar.alpha = 0
                postButton.isEnabled = false
                postButton.setTitleColor(.donGray9, for: .normal)
                postButton.backgroundColor = .donGray3
                impactFeedbackGenerator.impactOccurred()
            }
        }
    }
}
