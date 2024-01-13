//
//  PostView.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/12/24.
//

import UIKit

import SnapKit

final class PostView: UIView {

    // MARK: - Properties
    
    var KebabButtonAction: (() -> Void) = {}
    var LikeButtonAction: (() -> Void) = {}
    var TransparentButtonAction: (() -> Void) = {}
    var isLiked: Bool = false
    
    // MARK: - UI Components
    
    let PostbackgroundUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .donWhite
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderWidth = 1.adjusted
        image.layer.borderColor = UIColor.clear.cgColor
        image.image = ImageLiterals.Onboarding.imgOne
        return image
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donBlack
        label.text = "Don't be야 사랑해~"
        label.font = .font(.body3)
        return label
    }()
    
    private let transparentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donGray9
        label.text = "투명도 0%"
        label.font = .font(.caption4)
        return label
    }()
    
    private let dotLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donGray9
        label.text = "·"
        label.font = .font(.caption4)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donGray9
        label.text = "3분 전"
        label.font = .font(.caption4)
        return label
    }()
    
    private let kebabButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Posting.btnKebab, for: .normal)
        return button
    }()
    
    private let contentTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donBlack
        label.text = "돈비를 사용하면 진짜 돈비를 맞을 수 있나요? 저 돈비 맞고 싶어요 돈벼락이 최고입니다."
        label.lineBreakMode = .byCharWrapping
        label.font = .font(.body4)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var likeStackView: UIStackView = {
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
    
    private let likeNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donGray11
        label.text = "54"
        label.font = .font(.caption4)
        return label
    }()
    
    private lazy var commentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(commentButton, commentNumLabel)
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Posting.btnComment, for: .normal)
        return button
    }()
    
    private let commentNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donGray11
        label.text = "54"
        label.font = .font(.caption4)
        return label
    }()
    
    private let ghostButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Posting.btnTransparent, for: .normal)
        return button
    }()
    
    private let verticalTextBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .donPale
        return view
    }()
    
    public let horizontalDivierView: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray2
        return view
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
        setRegisterCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension PostView {
    private func setUI() {
        self.backgroundColor = .donGray1
    }
    
    private func setHierarchy() {
        addSubviews(PostbackgroundUIView, horizontalDivierView)
        
        PostbackgroundUIView.addSubviews(profileImageView,
                                     nicknameLabel,
                                     transparentLabel,
                                     dotLabel,
                                     timeLabel,
                                     kebabButton,
                                     contentTextLabel,
                                     commentStackView,
                                     likeStackView,
                                     ghostButton,
                                     verticalTextBarView)
        
        commentStackView.addArrangedSubviews(commentButton, commentNumLabel)
        likeStackView.addArrangedSubviews(likeButton,
                                          likeNumLabel)
    }
    
    func setLayout() {
        PostbackgroundUIView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
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
        
        horizontalDivierView.snp.makeConstraints {
            $0.top.equalTo(PostbackgroundUIView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.adjusted)
        }
    }
    
    func setAddTarget() {
        kebabButton.addTarget(self, action: #selector(showButtons), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeToggleButton), for: .touchUpInside)
        ghostButton.addTarget(self, action: #selector(transparentShowPopupButton), for: .touchUpInside)
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
    
    private func setRegisterCell() {
        
    }
    
    private func setDataBind() {
        
    }
}
