//
//  PostReplyCollectionViewCell.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/12/24.
//

import UIKit

import SnapKit

final class PostReplyCollectionViewCell: UICollectionViewCell, UICollectionViewRegisterable {
    
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
    
    private let backgroundUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .donWhite
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
        image.image = ImageLiterals.Common.imgProfile
        image.layer.cornerRadius = 22.adjusted
        image.isUserInteractionEnabled = true
        return image
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donBlack
        label.text = "Don't be야 사랑해~"
        label.font = .font(.body3)
        return label
    }()
    
    let transparentLabel: UILabel = {
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
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donGray9
        label.text = "3분 전"
        label.font = .font(.caption4)
        return label
    }()
    
    let kebabButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Posting.btnKebab, for: .normal)
        return button
    }()
    
    let contentTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donBlack
        label.text = "돈비를 사용하면 진짜 돈비를 맞을 수 있나요? 저 돈비 맞고 싶어요 돈벼락이 최고입니다. 돈비를 사용하면 진짜 돈비를 맞을 수 있나요? 저 돈비 맞고 싶어요 돈벼락이 최고입니다."
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
    
    let likeNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donGray11
        label.text = "54"
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
        view.backgroundColor = .donPale
        return view
    }()
    
    private let horizontalCellBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray3
        return view
    }()
    
    private let horizontalCellBarCircleView : UIView = {
        let view = UIView()
        view.backgroundColor = .donGray3
        view.layer.cornerRadius = 6.adjusted
        return view
    }()
    
    private let verticalBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray3
        return view
    }()
    
    private let cellSpacingView: UIView = {
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
}

// MARK: - Extensions

extension PostReplyCollectionViewCell {
    func setUI() {
        kebabButton.contentMode = .scaleAspectFill
    }
    
    func setHierarchy() {
        contentView.addSubviews(horizontalCellBarCircleView,
                                backgroundUIView,
                                horizontalCellBarView,
                                verticalBarView,
                                grayView)
        
        backgroundUIView.addSubviews(profileImageView,
                                     nicknameLabel,
                                     transparentLabel,
                                     dotLabel,
                                     timeLabel,
                                     kebabButton,
                                     contentTextLabel,
                                     likeStackView,
                                     ghostButton,
                                     verticalTextBarView,
                                     cellSpacingView)
        
        likeStackView.addArrangedSubviews(likeButton,
                                          likeNumLabel)
    }
    
    func setLayout() {
        backgroundUIView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(14.adjusted)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width - 64.adjusted)
        }
        
        grayView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(14.adjusted)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width - 64.adjusted)
        }
        
        horizontalCellBarView.snp.makeConstraints {
            $0.centerY.equalTo(backgroundUIView)
            $0.trailing.equalTo(backgroundUIView.snp.leading)
            $0.height.equalTo(1.adjusted)
            $0.width.equalTo(22.adjusted)
            $0.leading.equalToSuperview()
        }
        
        horizontalCellBarCircleView.snp.makeConstraints {
            $0.centerY.equalTo(horizontalCellBarView)
            $0.size.equalTo(8.adjusted)
            $0.leading.equalTo(backgroundUIView.snp.leading).inset(-4.adjusted)
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
            $0.trailing.equalToSuperview().inset(6.adjusted)
            $0.size.equalTo(34.adjusted)
        }
        
        contentTextLabel.snp.makeConstraints {
            $0.top.equalTo(transparentLabel.snp.bottom).offset(8.adjusted)
            $0.leading.equalTo(nicknameLabel)
            $0.trailing.equalToSuperview().inset(20.adjusted)
        }
        
        likeStackView.snp.makeConstraints {
            $0.top.equalTo(contentTextLabel.snp.bottom).offset(4.adjusted)
            $0.height.equalTo(42.adjusted)
            $0.trailing.equalTo(kebabButton).inset(8.adjusted)
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
        
        verticalBarView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(horizontalCellBarView.snp.leading)
            $0.width.equalTo(1)
        }
        
        cellSpacingView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalTo(backgroundUIView)
            $0.height.equalTo(8)
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
