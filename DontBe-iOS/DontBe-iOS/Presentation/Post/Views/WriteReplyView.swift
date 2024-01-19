//
//  WriteReplyView.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/14/24.
//

import UIKit

import SnapKit

final class WriteReplyView: UIView {
    
    // MARK: - Properties
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy) // 햅틱 기능
    let maxLength = 500 // 최대 글자 수
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    public lazy var writeReplyPostview = WriteReplyPostView()
    public lazy var writeReplyView = WriteReplyEditorView()
    
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
        setHierarchy()
        setLayout()
        setDelegate()
        setObserver()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension WriteReplyView {
    private func setUI() {
    }
    
    private func setHierarchy() {
        self.addSubviews(scrollView, keyboardToolbarView)
        scrollView.addSubviews(contentView)
        contentView.addSubviews(writeReplyPostview,
                               writeReplyView)
        keyboardToolbarView.addSubviews(circleProgressBar,
                                        limitedCircleProgressBar,
                                        postButton)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(900.adjusted)
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
        
        writeReplyPostview.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(500.adjusted)
        }
        
        writeReplyView.snp.makeConstraints {
            $0.top.equalTo(writeReplyPostview.contentTextLabel.snp.bottom).offset(24.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(500.adjusted)
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
    
    private func setDelegate() {
        self.writeReplyView.contentTextView.delegate = self
    }
    
    private func setObserver() {
        writeReplyView.contentTextView.becomeFirstResponder()
        limitedCircleProgressBar.alpha = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // 햅틱 피드백 생성
        impactFeedbackGenerator.prepare()
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            writeReplyView.contentTextView.snp.remakeConstraints {
                $0.top.equalTo(writeReplyView.userNickname.snp.bottom).offset(4.adjusted)
                $0.leading.equalTo(writeReplyView.userNickname.snp.leading)
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
}

extension WriteReplyView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let textLength = writeReplyView.contentTextView.text.count
        textView.text = String(textView.text.prefix(maxLength))
        
        if textLength == 0 {
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
            } else {
                limitedCircleProgressBar.alpha = 1
                circleProgressBar.alpha = 0
                postButton.isEnabled = false
                
                impactFeedbackGenerator.impactOccurred()
            }
        }
    }
}

