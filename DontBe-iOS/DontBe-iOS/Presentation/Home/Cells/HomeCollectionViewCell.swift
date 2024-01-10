//
//  HomeCollectionViewCell.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/8/24.
//

import UIKit

final class HomeCollectionViewCell: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let backgroundUIView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.donWhite
        view.layer.cornerRadius = 8.adjusted
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderWidth = 1.adjusted
        image.layer.borderColor = UIColor.clear.cgColor
        image.image = UIImage.checkmark
        return image
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .donBlack
        label.text = "Don't be야 사랑해~"
        label.font = .font(.body3)
        return label
    }()
    
    private let transparentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .donGray9
        label.text = "투명도 0%"
        label.font = .font(.caption4)
        return label
    }()
    
    private let dotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .donGray9
        label.text = "·"
        label.font = .font(.caption4)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .donBlack
        label.text = "돈비를 사용하면 진짜 돈비를 맞을 수 있나요? 저 돈비 맞고 싶어요 돈벼락이 최고입니다. 그나저나 돈비 정말 흥미로운 서비스인 것 같아요 어떻게 이런 기획을 ? 대박 ㄷ ㄷ ㄷ 돈비를 사용하면 진짜 돈비를 맞을 수 있나요?"
        label.font = .font(.body4)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var likeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(likeButton, likeNumLabel)
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Posting.btnFavoriteInActive, for: .normal)
        return button
    }()
    
    private let likeNumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
        label.translatesAutoresizingMaskIntoConstraints = false
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
        view.backgroundColor = UIColor.donPale
        return view
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension HomeCollectionViewCell {
    func setUI() {
        kebabButton.contentMode = .scaleAspectFill
    }
    
    func setHierarchy() {
        contentView.addSubviews(backgroundUIView)
        backgroundUIView.addSubviews(profileImageView, nicknameLabel, transparentLabel, dotLabel, timeLabel, kebabButton, contentTextLabel, commentStackView, likeStackView, ghostButton, verticalTextBarView)
    }
    
    func setLayout() {
        backgroundUIView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
            $0.trailing.equalTo(kebabButton.snp.trailing).inset(12.adjusted)
        }
        commentStackView.snp.makeConstraints {
            $0.top.equalTo(contentTextLabel.snp.bottom).offset(4.adjusted)
            $0.height.equalTo(42.adjusted)
            $0.trailing.equalTo(likeStackView.snp.leading).offset(-10.adjusted)
        }
        likeStackView.snp.makeConstraints {
            $0.top.equalTo(commentStackView)
            $0.height.equalTo(commentStackView)
            $0.trailing.equalTo(kebabButton).inset(8.adjusted)
        }
        ghostButton.snp.makeConstraints {
            $0.bottom.equalTo(commentStackView.snp.bottom).offset(-4.adjusted)
            $0.leading.equalTo(profileImageView)
            $0.size.equalTo(44.adjusted)
        }
        verticalTextBarView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom)
            $0.bottom.equalTo(ghostButton.snp.top)
            $0.width.equalTo(1.adjusted)
            $0.centerX.equalTo(profileImageView)
        }
    }
}