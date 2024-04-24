//
//  HomeCollectionViewCell.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/8/24.
//

import UIKit

import SnapKit

final class HomeCollectionViewCell: UICollectionViewCell, UICollectionViewRegisterable {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = ImageLiterals.Common.imgProfile
    }
    
    // MARK: - Properties
    
    var KebabButtonAction: (() -> Void) = {}
    var LikeButtonAction: (() -> Void) = {}
    var TransparentButtonAction: (() -> Void) = {}
    var ProfileButtonAction: (() -> Void) = {}
    var isLiked: Bool = false
    var alarmTriggerType: String = ""
    var targetMemberId: Int = 0
    var alarmTriggerdId: Int = 0
    
    // MARK: - UI Components
    
    let backgroundUIView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.donWhite
        view.layer.cornerRadius = 8.adjusted
        return view
    }()
    
    let grayView: DontBeTransparencyGrayView = {
        let view = DontBeTransparencyGrayView()
        view.layer.cornerRadius = 8.adjusted
        view.alpha = 0
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderWidth = 1.adjusted
        image.layer.borderColor = UIColor.clear.cgColor
        image.layer.cornerRadius = 22.adjusted
        image.isUserInteractionEnabled = true
        return image
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donBlack
        label.text = ""
        label.font = .font(.body3)
        return label
    }()
    
    let transparentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donGray9
        label.text = ""
        label.font = .font(.caption4)
        return label
    }()
    
    let dotLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donGray9
        label.text = ""
        label.font = .font(.caption4)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donGray9
        label.text = ""
        label.font = .font(.caption4)
        return label
    }()
    
    let kebabButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Posting.btnKebab, for: .normal)
        return button
    }()
    
    let contentTextLabel: CopyableLabel = {
        let label = CopyableLabel()
        label.textColor = .donBlack
        label.text = ""
        label.lineBreakMode = .byCharWrapping
        label.font = .font(.body4)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var likeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Posting.btnFavoriteInActive, for: .normal)
        return button
    }()
    
    let likeNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donGray11
        label.text = ""
        label.font = .font(.caption4)
        return label
    }()
    
    lazy var commentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Posting.btnComment, for: .normal)
        return button
    }()
    
    let commentNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donGray11
        label.text = ""
        label.font = .font(.caption4)
        return label
    }()
    
    let ghostButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Posting.btnTransparent, for: .normal)
        return button
    }()
    
    let verticalTextBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.donPale
        return view
    }()
    
    private let cellTopSpacingView: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray1
        return view
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with postText: String) {
        contentTextLabel.attributedText = attributedString(for: postText)
         
        // 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        contentTextLabel.isUserInteractionEnabled = true
        contentTextLabel.addGestureRecognizer(tapGesture)
    }
    
    // URL을 하이퍼링크로 바꾸는 함수
    private func attributedString(for text: String) -> NSAttributedString {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return NSAttributedString(string: text)
        }
        
        let attributedString = NSMutableAttributedString(string: text)
        let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        for match in matches {
            guard let range = Range(match.range, in: text) else { continue }
            let url = text[range]
            attributedString.addAttribute(.link, value: url, range: NSRange(range, in: text))
        }
        
        return attributedString
    }
    
    // 탭 제스처 처리 함수
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let attributedText = contentTextLabel.attributedText else { return }
        
        let location = gesture.location(in: contentTextLabel)
        let index = contentTextLabel.indexOfAttributedTextCharacterAtPoint(point: location)
        
        attributedText.enumerateAttribute(.link, in: NSRange(location: 0, length: attributedText.length), options: []) { value, range, _ in
            if let url = value as? String, NSLocationInRange(index, range) {
                if let url = URL(string: url) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}

// MARK: - Extensions

extension HomeCollectionViewCell {
    func setUI() {
        kebabButton.contentMode = .scaleAspectFill
        commentStackView.isUserInteractionEnabled = false
    }
    
    func setHierarchy() {
        contentView.addSubviews(backgroundUIView)
        
        backgroundUIView.addSubviews(profileImageView,
                                     nicknameLabel,
                                     transparentLabel,
                                     dotLabel,
                                     timeLabel,
                                     contentTextLabel,
                                     grayView,
                                     kebabButton,
                                     commentStackView,
                                     likeStackView,
                                     ghostButton,
                                     verticalTextBarView,
                                     cellTopSpacingView)
        
        commentStackView.addArrangedSubviews(commentButton, 
                                             commentNumLabel)
        
        likeStackView.addArrangedSubviews(likeButton,
                                          likeNumLabel)
        
        kebabButton.bringSubviewToFront(contentView)
        ghostButton.bringSubviewToFront(contentView)
        likeStackView.bringSubviewToFront(contentView)
        commentStackView.bringSubviewToFront(contentView)
    }
    
    func setLayout() {
        backgroundUIView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.adjusted)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width - 32.adjusted)
        }
        
        grayView.snp.makeConstraints {
            $0.edges.equalTo(backgroundUIView)
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(10.adjusted)
            $0.top.equalTo(18.adjusted)
            $0.size.equalTo(44.adjusted)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8.adjusted)
            $0.top.equalTo(profileImageView.snp.top).offset(4.adjusted)
        }
        
        transparentLabel.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel)
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(4.adjusted)
        }
        
        dotLabel.snp.makeConstraints {
            $0.leading.equalTo(transparentLabel.snp.trailing).offset(8.adjusted)
            $0.top.equalTo(transparentLabel)
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(dotLabel.snp.trailing).offset(8.adjusted)
            $0.top.equalTo(transparentLabel)
        }
        
        kebabButton.snp.makeConstraints {
            $0.top.equalTo(24.adjusted)
            $0.trailing.equalToSuperview().inset(12.adjusted)
            $0.size.equalTo(34.adjusted)
        }
        
        contentTextLabel.snp.makeConstraints {
            $0.top.equalTo(transparentLabel.snp.bottom).offset(8.adjusted)
            $0.leading.equalTo(nicknameLabel)
            $0.trailing.equalToSuperview().inset(20.adjusted)
        }
        
        commentStackView.snp.makeConstraints {
            $0.top.equalTo(contentTextLabel.snp.bottom).offset(4.adjusted)
            $0.height.equalTo(commentStackView)
            $0.trailing.equalTo(kebabButton).inset(8.adjusted)
            $0.bottom.equalToSuperview().inset(16.adjusted)
        }
        
        likeStackView.snp.makeConstraints {
            $0.top.equalTo(commentStackView)
            $0.height.equalTo(42.adjusted)
            $0.trailing.equalTo(commentStackView.snp.leading).offset(-10.adjusted)
            $0.bottom.equalToSuperview().inset(16.adjusted)
        }
        
        ghostButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16.adjusted)
            $0.leading.equalTo(profileImageView)
            $0.size.equalTo(44.adjusted)
        }
        
        verticalTextBarView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom)
            $0.bottom.equalTo(ghostButton.snp.top)
            $0.width.equalTo(1.adjusted)
            $0.centerX.equalTo(profileImageView)
        }
        
        cellTopSpacingView.snp.makeConstraints {
            $0.bottom.equalTo(backgroundUIView.snp.top)
            $0.width.equalTo(backgroundUIView.snp.width)
            $0.top.equalToSuperview()
            $0.leading.equalTo(backgroundUIView.snp.leading)
        }
    }
    
    func setAddTarget() {
        kebabButton.addTarget(self, action: #selector(showButtons), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeToggleButton), for: .touchUpInside)
        ghostButton.addTarget(self, action: #selector(transparentShowPopupButton), for: .touchUpInside)
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileButton)))
    }
    
    @objc
    func showButtons() {
        KebabButtonAction()
    }
    
    @objc
    func likeToggleButton() {
        LikeButtonAction()
    }
    @objc
    func transparentShowPopupButton() {
        TransparentButtonAction()
    }
    
    @objc
    func profileButton() {
        ProfileButtonAction()
    }
}
