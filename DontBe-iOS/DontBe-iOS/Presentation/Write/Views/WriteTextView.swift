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
    var isHiddenLinkView = true
    
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
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainer.maximumNumberOfLines = 0
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    
    let linkTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.font(.body4)
        textView.textColor = .donBlack
        textView.tintColor = .donPrimary
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
    
    private let errorLinkView: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray1
        view.layer.cornerRadius = 4.adjusted
        view.isHidden = true
        return view
    }()
    
    private let errorLinkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.caption4)
        label.text = StringLiterals.Write.writeErrorLink
        label.textColor = .donGray12
        return label
    }()
    
    private let onlyOneLinkView: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray1
        view.layer.cornerRadius = 4.adjusted
        view.isHidden = true
        return view
    }()
    
    private let onlyOneLinkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.caption4)
        label.text = StringLiterals.Write.writeOnlyOneLink
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
        setAddTarget()
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
        self.linkTextView.delegate = self
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
                         linkTextView,
                         linkCloseButton,
                         errorLinkView,
                         onlyOneLinkView,
                         keyboardToolbarView)
        
        errorLinkView.addSubview(errorLinkLabel)
        onlyOneLinkView.addSubview(onlyOneLinkLabel)
        
        keyboardToolbarView.addSubviews(circleProgressBar,
                                        limitedCircleProgressBar,
                                        linkButton,
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
            $0.height.equalTo(25.adjusted)
        }
        
        linkTextView.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(11.adjusted)
            $0.leading.equalTo(contentTextView.snp.leading)
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
            $0.leading.equalTo(linkTextView.snp.leading)
            $0.trailing.equalTo(linkCloseButton.snp.leading).offset(7.adjusted)
            $0.height.equalTo(34.adjusted)
        }
        
        errorLinkLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        onlyOneLinkView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.adjusted)
            $0.bottom.equalTo(keyboardToolbarView.snp.top).offset(-8.adjusted)
            $0.height.equalTo(34.adjusted)
        }
        
        onlyOneLinkLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(28.adjusted)
            $0.centerY.equalToSuperview()
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
        }
    }
    
    @objc private func linkCloseButtonTapped() {
        isHiddenLinkView = true
        linkTextView.isHidden = true
        linkCloseButton.isHidden = true
        errorLinkView.isHidden = true
        
        linkTextView.text = nil
        contentTextView.becomeFirstResponder()
        
        let contentTextLength = contentTextView.text.count
        let linkLength = linkTextView.text.count
        
        let totalTextLength = contentTextLength + linkLength
        let value = Double(totalTextLength) / 500
        circleProgressBar.value = value
        postButton.setTitleColor(.donGray9, for: .normal)
        postButton.backgroundColor = .donGray3
        postButton.isEnabled = false
    }
    
    func isValidURL(_ urlString: String) -> Bool {
        // URL의 정규식 패턴
        let urlPattern = #"^(http|https)://[a-zA-Z0-9\-\.]+\.(com|co|kr)"#
        
        // 정규식과 매칭되는지 확인
        if let regex = try? NSRegularExpression(pattern: urlPattern, options: .caseInsensitive) {
            let range = NSRange(location: 0, length: urlString.utf16.count)
            return regex.firstMatch(in: urlString, options: [], range: range) != nil
        }
        
        return false
    }
}

extension WriteTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        onlyOneLinkView.isHidden = true
        let contentTextLength = contentTextView.text.count
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
            postButton.setTitleColor(.donBlack, for: .normal)
            postButton.backgroundColor = .donPrimary
            postButton.isEnabled = true
            
            if totalTextLength < 500 {
                limitedCircleProgressBar.alpha = 0
                circleProgressBar.alpha = 1
                
                let value = Double(totalTextLength) / 500
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
        
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        if textView == contentTextView {
            let minHeight: CGFloat = 25 // 최소 높이
            let maxHeight: CGFloat = 300.adjusted // 최대 높이

            var newHeight = estimatedSize.height
            if newHeight < minHeight {
                newHeight = minHeight
            } else if newHeight > maxHeight {
                newHeight = maxHeight
            }

            textView.snp.updateConstraints { make in
                make.height.equalTo(newHeight)
            }
        } else if textView == linkTextView {
            let minHeight: CGFloat = 25 // 최소 높이
            let maxHeight: CGFloat = 100.adjusted // 최대 높이

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
                postButton.setTitleColor(.donBlack, for: .normal)
                postButton.backgroundColor = .donPrimary
                postButton.isEnabled = true
                errorLinkView.isHidden = true
            } else {
                postButton.setTitleColor(.donGray9, for: .normal)
                postButton.backgroundColor = .donGray3
                postButton.isEnabled = false
                errorLinkView.isHidden = false
            }
        }
    }
}
