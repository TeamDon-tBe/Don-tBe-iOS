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
    var currentTextLength = 0 // 현재 글자 수
    let maxLength = 500 // 최대 글자 수
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
    
    var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4.adjusted
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var removePhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Write.btnCloseLink, for: .normal)
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
    
    public let linkButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Write.btnLink, for: .normal)
        return button
    }()
    
    public let photoButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Write.btnPhoto, for: .normal)
        return button
    }()
    
    private let textCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.caption3)
        label.text = "(0/500)"
        label.textColor = .donGray6
        return label
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
                                photoImageView,
                                errorLinkView,
                                onlyOneLinkView)
        
        photoImageView.addSubview(removePhotoButton)
        removePhotoButton.bringSubviewToFront(photoImageView)
        
        errorLinkView.addSubview(errorLinkLabel)
        onlyOneLinkView.addSubview(onlyOneLinkLabel)
        
        keyboardToolbarView.addSubviews(linkButton,
                                        photoButton,
                                        textCountLabel,
                                        postButton)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(1500.adjusted)
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
            $0.height.equalTo(800.adjusted)
        }
        
        linkTextView.snp.makeConstraints {
            $0.top.equalTo(writeReplyView.contentTextView.snp.bottom).offset(11.adjusted)
            $0.leading.equalTo(writeReplyView.contentTextView.snp.leading)
            $0.trailing.equalTo(linkCloseButton.snp.leading).offset(-2.adjusted)
            $0.height.equalTo(25.adjusted)
        }
        
        linkCloseButton.snp.makeConstraints {
            $0.top.equalTo(linkTextView.snp.top).offset(-12.adjusted)
            $0.trailing.equalToSuperview().inset(16.adjusted)
            $0.size.equalTo(44.adjusted)
        }
        
        photoImageView.snp.makeConstraints {
            $0.top.equalTo(writeReplyView.contentTextView.snp.bottom).offset(11.adjusted)
            $0.leading.equalTo(writeReplyView.contentTextView.snp.leading)
            $0.trailing.equalTo(writeReplyView.contentTextView.snp.trailing)
            $0.height.equalTo(345.adjusted)
        }
        
        removePhotoButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(8.adjusted)
            $0.size.equalTo(44)
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
        
        linkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(11.adjusted)
            $0.size.equalTo(44.adjusted)
        }
        
        photoButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(linkButton.snp.trailing)
            $0.size.equalTo(44.adjusted)
        }
        
        textCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(postButton.snp.leading).offset(-9.adjusted)
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

        impactFeedbackGenerator.prepare()
    }
    
    func setAddTarget() {
        linkButton.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
        linkCloseButton.addTarget(self, action: #selector(linkCloseButtonTapped), for: .touchUpInside)
        removePhotoButton.addTarget(self, action: #selector(removePhotoButtonTapped), for: .touchUpInside)
    }
    
    @objc private func linkButtonTapped() {
        if isHiddenLinkView == true {
            postButton.setTitleColor(.donGray9, for: .normal)
            postButton.backgroundColor = .donGray3
            postButton.isEnabled = false
            
            isHiddenLinkView = false
            
            linkTextView.isHidden = false
            linkCloseButton.isHidden = false
            
            linkTextView.addPlaceholder(StringLiterals.Write.writeLinkPlaceholder, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            
            linkTextView.becomeFirstResponder()
            
            photoImageView.snp.remakeConstraints {
                $0.top.equalTo(linkTextView.snp.bottom).offset(11.adjusted)
                $0.leading.equalTo(writeReplyView.contentTextView.snp.leading)
                $0.trailing.equalToSuperview().inset(16.adjusted)
                $0.height.equalTo(386.adjusted)
            }
        } else {
            onlyOneLinkView.isHidden = false
        }
    }
    
    @objc private func linkCloseButtonTapped() {
        isHiddenLinkView = true
        linkTextView.isHidden = true
        linkCloseButton.isHidden = true
        errorLinkView.isHidden = true
        onlyOneLinkView.isHidden = true
        
        if let contentText = writeReplyView.contentTextView.text {
            if contentText == "" {
                postButton.setTitleColor(.donGray9, for: .normal)
                postButton.backgroundColor = .donGray3
                postButton.isEnabled = false
            } else {
                postButton.setTitleColor(.donBlack, for: .normal)
                postButton.backgroundColor = .donPrimary
                postButton.isEnabled = true
            }
        }
        
        linkTextView.text = nil
        writeReplyView.contentTextView.becomeFirstResponder()
        
        let contentTextLength = writeReplyView.contentTextView.text.count
        let linkLength = linkTextView.text.count
        
        self.currentTextLength = contentTextLength + linkLength
        textCountLabel.text = "(\(self.currentTextLength)/\(self.maxLength))"
    }
    
    @objc private func removePhotoButtonTapped() {
        photoImageView.isHidden = true
        photoImageView.image = nil
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
        if onlyOneLinkView.isHidden == false {
            onlyOneLinkView.isHidden = true
        }
        
        let contentTextLength = writeReplyView.contentTextView.text.count
        let linkLength = linkTextView.text.count
        
        if textView == linkTextView {
            if isValidURL(textView.text) {
                isValidURL = true
                errorLinkView.isHidden = true
                
                photoImageView.snp.remakeConstraints {
                    $0.top.equalTo(linkTextView.snp.bottom).offset(11.adjusted)
                    $0.leading.equalTo(writeReplyView.contentTextView.snp.leading)
                    $0.trailing.equalTo(writeReplyView.contentTextView.snp.trailing)
                    $0.height.equalTo(345.adjusted)
                }
            } else {
                isValidURL = false

                if linkLength == 0 {
                    errorLinkView.isHidden = true
                    
                    photoImageView.snp.remakeConstraints {
                        $0.top.equalTo(linkTextView.snp.bottom).offset(11.adjusted)
                        $0.leading.equalTo(writeReplyView.contentTextView.snp.leading)
                        $0.trailing.equalTo(writeReplyView.contentTextView.snp.trailing)
                        $0.height.equalTo(345.adjusted)
                    }
                } else {
                    errorLinkView.isHidden = false
                    
                    photoImageView.snp.remakeConstraints {
                        $0.top.equalTo(errorLinkView.snp.bottom).offset(11.adjusted)
                        $0.leading.equalTo(writeReplyView.contentTextView.snp.leading)
                        $0.trailing.equalTo(writeReplyView.contentTextView.snp.trailing)
                        $0.height.equalTo(345.adjusted)
                    }
                }
            }
        }
        
        self.currentTextLength = contentTextLength + linkLength
        textView.text = String(textView.text.prefix(maxLength))
        
        if self.currentTextLength == 0 {
            postButton.setTitleColor(.donGray9, for: .normal)
            postButton.backgroundColor = .donGray3
            postButton.isEnabled = false
            textCountLabel.textColor = .donGray6
        } else {
            if self.currentTextLength < 500 {
                if isValidURL == true || linkTextView.text == "" {
                    postButton.setTitleColor(.donBlack, for: .normal)
                    postButton.backgroundColor = .donPrimary
                    postButton.isEnabled = true
                    textCountLabel.textColor = .donGray6
                } else {
                    postButton.setTitleColor(.donGray9, for: .normal)
                    postButton.backgroundColor = .donGray3
                    postButton.isEnabled = false
                    textCountLabel.textColor = .donGray6
                }
            } else {
                self.currentTextLength = 500
                postButton.isEnabled = false
                postButton.setTitleColor(.donGray9, for: .normal)
                postButton.backgroundColor = .donGray3
                textCountLabel.textColor = .donError
                impactFeedbackGenerator.impactOccurred()
            }
        }
        
        textCountLabel.text = "(\(self.currentTextLength)/\(self.maxLength))"
        
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
            
            contentView.snp.updateConstraints { make in
                make.height.equalTo(1500.adjusted + newHeight)
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
        }
    }
}

