//
//  PostCollectionViewHeader.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/18/24.
//

import UIKit

import SnapKit

final class PostCollectionViewHeader: UICollectionReusableView {

    // MARK: - Properties
    
    static let identifier = "PostCollectionViewHeader"
    
    var deleteBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnDelete)
    
    var warnBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnWarn
    )
    var isLiked: Bool = false
    
    override func prepareForReuse() {
      super.prepareForReuse()
    }
    
    // MARK: - UI Components
    
    var PostbackgroundUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .donWhite
        return view
    }()
    
    var grayView: DontBeTransparencyGrayView = {
        let view = DontBeTransparencyGrayView()
        view.alpha = 0
        view.isUserInteractionEnabled = false
        return view
    }()
    
    var profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 22.adjusted
        image.image = ImageLiterals.Common.imgProfile
        return image
    }()
    
    var postNicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donBlack
        label.text = "sdasdasdasdasdsa"
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
        label.text = "·"
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
    
    let contentTextLabel: UILabel = {
        let label = UILabel()
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
        stackView.addArrangedSubviews(commentButton, commentNumLabel)
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
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension PostCollectionViewHeader {
    private func setUI() {
        self.backgroundColor = .donGray1
    }
    
    private func setHierarchy() {
        addSubviews(PostbackgroundUIView, horizontalDivierView, grayView)
        
        PostbackgroundUIView.addSubviews(profileImageView,
                                         postNicknameLabel,
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
        
        grayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(10.adjusted)
            $0.top.equalTo(18.adjusted)
            $0.size.equalTo(44.adjusted)
        }
        
        postNicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8.adjusted)
            $0.top.equalTo(profileImageView.snp.top).offset(4.adjusted)
        }
        
        transparentLabel.snp.makeConstraints {
            $0.leading.equalTo(postNicknameLabel)
            $0.top.equalTo(postNicknameLabel.snp.bottom).offset(4.adjusted)
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
            $0.leading.equalTo(postNicknameLabel)
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
            $0.bottom.equalTo(PostbackgroundUIView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.adjusted)
        }
    }
    
    func setAddTarget() {
        likeButton.addTarget(self, action: #selector(likeToggleButton), for: .touchUpInside)
    }
    
    @objc
    func likeToggleButton() {
        if isLiked == true {
            likeNumLabel.text = String((Int(likeNumLabel.text ?? "") ?? 0) - 1)
        } else {
            likeNumLabel.text = String((Int(likeNumLabel.text ?? "") ?? 0) + 1)
        }
        isLiked.toggle()
        likeButton.setImage(isLiked ? ImageLiterals.Posting.btnFavoriteActive : ImageLiterals.Posting.btnFavoriteInActive, for: .normal)
        NotificationCenter.default.post(name: NSNotification.Name("likeButtonTapped"), object: nil, userInfo: nil)
    }
}
