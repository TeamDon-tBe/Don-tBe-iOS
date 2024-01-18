//
//  WriteReplyEditorView.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/14/24.
//

import UIKit

import SnapKit

final class WriteReplyEditorView: UIView {

    // MARK: - Properties
    
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy) // 햅틱 기능
    let maxLength = 500 // 최대 글자 수
    
    // MARK: - UI Components
    
    private let backgroundUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .donWhite
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let userProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.load(url: StringLiterals.Network.baseImageURL)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var userNickname: UILabel = {
        let label = UILabel()
        label.text = "\(loadUserData()?.userNickname ?? "")"
        label.font = UIFont.font(.body1)
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
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainer.maximumNumberOfLines = 0
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
    
    let postButton: UIButton = {
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
        
        setUI()
        setObserver()
        setHierarchy()
        setLayout()
        setDelegate()
        setAddTarget()
        setRegisterCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension WriteReplyEditorView {
    func setUI() {
        self.backgroundColor = .donGray1
    }
    func setDelegate() {
        self.contentTextView.delegate = self
        
    }
    
    private func setObserver() {
        contentTextView.becomeFirstResponder()
        limitedCircleProgressBar.alpha = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // 햅틱 피드백 생성
        impactFeedbackGenerator.prepare()
    }
    
    private func setHierarchy() {
        self.addSubviews(backgroundUIView,
                         keyboardToolbarView)
        
        backgroundUIView.addSubviews(userProfileImage,
                                     userNickname,
                                     contentTextView)
        
        keyboardToolbarView.addSubviews(circleProgressBar,
                                        limitedCircleProgressBar,
                                        postButton)
    }
    
    private func setLayout() {
        backgroundUIView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(8)
            $0.bottom.equalToSuperview()
        }
        
        userProfileImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18.adjusted)
            $0.leading.equalToSuperview().offset(10.adjusted)
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
            $0.bottom.equalToSuperview()
        }
        
        keyboardToolbarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56.adjusted)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
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
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            contentTextView.snp.remakeConstraints {
                $0.top.equalTo(userNickname.snp.bottom).offset(4.adjusted)
                $0.leading.equalTo(userNickname.snp.leading)
                $0.trailing.equalToSuperview().inset(16.adjusted)
                $0.bottom.equalTo(-keyboardHeight)
            }
            
            keyboardToolbarView.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(56.adjusted)
                $0.bottom.equalTo(-keyboardHeight)
            }
        }
    }
    
    private func setAddTarget() {

    }
    
    private func setRegisterCell() {
        
    }
    
    private func setDataBind() {
        
    }
}

extension WriteReplyEditorView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let textLength = contentTextView.text.count
        textView.text = String(textView.text.prefix(maxLength))
        
        if textLength == 0 {
            postButton.setTitleColor(.donGray9, for: .normal)
            postButton.backgroundColor = .donGray3
            postButton.isEnabled = false
        } else {
            postButton.setTitleColor(.donBlack, for: .normal)
            postButton.backgroundColor = .donPrimary
            postButton.isEnabled = true
        }
        
        if textLength < 500 {
            limitedCircleProgressBar.alpha = 0
            circleProgressBar.alpha = 1
            
            let value = Double(textLength) / 500
            circleProgressBar.value = value
            postButton.isEnabled = true
        } else {
            limitedCircleProgressBar.alpha = 1
            circleProgressBar.alpha = 0
            postButton.isEnabled = false
            
            impactFeedbackGenerator.impactOccurred()
        }
    }
}

