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
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    let maxLength = 500
    var isHiddenLinkView = true
    var isValidURL = false
    
    // MARK: - UI Components
    
    public lazy var writeReplyPostview = WriteReplyContentView()
    public lazy var writeReplyView = WriteReplyEditorView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    let linkTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.font(.body4)
        textView.textColor = .donBlack
        textView.tintColor = .donLink
        textView.backgroundColor = .clear
        textView.addPlaceholder(StringLiterals.Write.writeLinkPlaceholder, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainer.maximumNumberOfLines = 0
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.showsVerticalScrollIndicator = false
        textView.isHidden = true
        return textView
    }()
    
    var linkCloseButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Write.btnCloseLink, for: .normal)
        button.isHidden = true
        return button
    }()
    
    let errorLinkView: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray1
        view.layer.cornerRadius = 4.adjusted
        view.isHidden = true
        return view
    }()
    
    let errorLinkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.caption4)
        label.text = StringLiterals.Write.writeErrorLink
        label.textColor = .donGray12
        return label
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
    
    public let linkButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Write.btnLink, for: .normal)
        return button
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
    
    let onlyOneLinkView: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray1
        view.layer.cornerRadius = 4.adjusted
        view.isHidden = true
        return view
    }()
    
    let onlyOneLinkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.caption4)
        label.text = StringLiterals.Write.writeOnlyOneLink
        label.textColor = .donGray12
        return label
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setHierarchy()
        setLayout()
        setDelegate()
        setObserver()
        setAddTarget()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension WriteReplyView {
    
    private func setHierarchy() {
        self.addSubviews(scrollView, 
                         keyboardToolbarView)
        
        scrollView.addSubviews(contentView)
        
        contentView.addSubviews(writeReplyPostview,
                                writeReplyView,
                                linkTextView,
                                linkCloseButton,
                                errorLinkView,
                                onlyOneLinkView)
        
        errorLinkView.addSubview(errorLinkLabel)
        onlyOneLinkView.addSubview(onlyOneLinkLabel)
        
        keyboardToolbarView.addSubviews(circleProgressBar,
                                        limitedCircleProgressBar,
                                        linkButton,
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
            $0.height.equalTo(400.adjusted)
        }
        
        writeReplyView.snp.makeConstraints {
            $0.top.equalTo(writeReplyPostview.contentTextLabel.snp.bottom).offset(24.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(400.adjusted)
        }
        
        linkTextView.snp.makeConstraints {
            $0.top.equalTo(writeReplyView.contentTextView.snp.bottom).offset(11.adjusted)
            $0.leading.equalTo(writeReplyView.contentTextView.snp.leading)
            $0.trailing.equalTo(linkCloseButton.snp.leading).offset(-2.adjusted)
            $0.height.equalTo(25.adjusted)
        }
        
        linkCloseButton.snp.makeConstraints {
            $0.top.equalTo(linkTextView.snp.top).offset(-7.adjusted)
            $0.trailing.equalToSuperview().inset(16.adjusted)
            $0.size.equalTo(44.adjusted)
        }
        
        errorLinkView.snp.makeConstraints {
            $0.top.equalTo(linkTextView.snp.bottom).offset(19.adjusted)
            $0.leading.equalTo(writeReplyView.userProfileImage.snp.trailing)
            $0.trailing.equalTo(linkCloseButton.snp.leading)
            $0.height.equalTo(34.adjusted)
        }
        
        errorLinkLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
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
        
        linkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(11.adjusted)
            $0.size.equalTo(44.adjusted)
        }
        
        postButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16.adjusted)
            $0.width.equalTo(60.adjusted)
            $0.height.equalTo(36.adjusted)
        }
        
        onlyOneLinkView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(26.adjusted)
            $0.bottom.equalToSuperview().offset(-8.adjusted)
            $0.height.equalTo(34.adjusted)
        }
        
        onlyOneLinkLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(28.adjusted)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        self.writeReplyView.contentTextView.delegate = self
        self.linkTextView.delegate = self
    }
    
    private func setObserver() {
        writeReplyView.contentTextView.becomeFirstResponder()
        limitedCircleProgressBar.alpha = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        impactFeedbackGenerator.prepare()
    }
    
    func setAddTarget() {
        linkButton.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
        linkCloseButton.addTarget(self, action: #selector(linkCloseButtonTapped), for: .touchUpInside)
    }
    
    @objc private func linkButtonTapped() {
        if isHiddenLinkView == true {
            isHiddenLinkView = false
            
            linkTextView.isHidden = false
            linkCloseButton.isHidden = false
            
            linkTextView.addPlaceholder(StringLiterals.Write.writeLinkPlaceholder, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            
            linkTextView.becomeFirstResponder()
        } else {
            onlyOneLinkView.isHidden = false
            
            onlyOneLinkView.snp.makeConstraints {
                $0.bottom.equalTo(keyboardToolbarView.snp.top).offset(-5.adjusted)
            }
        }
    }
    
    @objc private func linkCloseButtonTapped() {
        isHiddenLinkView = true
        linkTextView.isHidden = true
        linkCloseButton.isHidden = true
        errorLinkView.isHidden = true
        
        linkTextView.text = nil
        writeReplyView.contentTextView.becomeFirstResponder()
        
        let contentTextLength = writeReplyView.contentTextView.text.count
        let linkLength = linkTextView.text.count
        
        let totalTextLength = contentTextLength + linkLength
        let value = Double(totalTextLength) / 500
        circleProgressBar.value = value
        postButton.setTitleColor(.donGray9, for: .normal)
        postButton.backgroundColor = .donGray3
        postButton.isEnabled = false
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
            
            scrollView.setContentOffset(CGPoint(x: 0, y: self.writeReplyPostview.contentTextLabel.frame.height), animated: true)
        }
    }
    
    func isValidURL(_ urlString: String) -> Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        // URL 여부 확인
        let range = NSRange(location: 0, length: urlString.utf16.count)
        if let match = detector.firstMatch(in: urlString, options: [], range: range) {
            // NSTextCheckingTypeLink가 아닌 경우는 URL이 아님
            if match.resultType != .link {
                return false
            }
            // URL의 범위가 입력된 문자열의 전체를 차지하지 않는 경우도 URL이 아님
            if match.range.location != 0 || match.range.length != urlString.utf16.count {
                return false
            }
            return true
        }
        // 일치하는 것이 없는 경우도 URL이 아님
        return false
    }
}

extension WriteReplyView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        onlyOneLinkView.isHidden = true
        let contentTextLength = writeReplyView.contentTextView.text.count
        let linkLength = linkTextView.text.count
        
        if linkLength == 0 {
            errorLinkView.isHidden = true
        }
        
        let totalTextLength = contentTextLength + linkLength
        textView.text = String(textView.text.prefix(maxLength))
        
        if totalTextLength == 0 {
            let value = Double(totalTextLength) / 500
            circleProgressBar.value = value
            postButton.setTitleColor(.donGray9, for: .normal)
            postButton.backgroundColor = .donGray3
            postButton.isEnabled = false
        } else {
            if totalTextLength < 500 {
                limitedCircleProgressBar.alpha = 0
                circleProgressBar.alpha = 1
                
                let value = Double(totalTextLength) / 500
                circleProgressBar.value = value
                
                if isValidURL == true || linkTextView.text == "" {
                    postButton.setTitleColor(.donBlack, for: .normal)
                    postButton.backgroundColor = .donPrimary
                    postButton.isEnabled = true
                } else {
                    postButton.setTitleColor(.donGray9, for: .normal)
                    postButton.backgroundColor = .donGray3
                    postButton.isEnabled = false
                }
            } else {
                limitedCircleProgressBar.alpha = 1
                circleProgressBar.alpha = 0
                postButton.isEnabled = false
                postButton.setTitleColor(.donGray9, for: .normal)
                postButton.backgroundColor = .donGray3
                impactFeedbackGenerator.impactOccurred()
            }
        }
        
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        if textView == writeReplyView.contentTextView {
            let minHeight: CGFloat = 25 // 최소 높이
            let maxHeight: CGFloat = 200.adjusted // 최대 높이

            var newHeight = estimatedSize.height
            if newHeight < minHeight {
                newHeight = minHeight
            } else if newHeight > maxHeight {
                newHeight = maxHeight
            }
            
            textView.snp.remakeConstraints {
                $0.top.equalTo(writeReplyView.userNickname.snp.bottom).offset(4.adjusted)
                $0.leading.equalTo(writeReplyView.userNickname.snp.leading)
                $0.trailing.equalToSuperview().inset(16.adjusted)
                $0.height.equalTo(newHeight)
            }
        } else if textView == linkTextView {
            let minHeight: CGFloat = 25 // 최소 높이
            let maxHeight: CGFloat = 80.adjusted // 최대 높이

            var newHeight = estimatedSize.height
            if newHeight < minHeight {
                newHeight = minHeight
            } else if newHeight > maxHeight {
                newHeight = maxHeight
            }

            textView.snp.updateConstraints { make in
                make.height.equalTo(newHeight)
            }
            
            if isValidURL(textView.text) {
                isValidURL = true
                errorLinkView.isHidden = true
            } else {
                isValidURL = false
                errorLinkView.isHidden = false
            }
        }
    }
}

