//
//  PostReplyTextFieldView.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/13/24.
//

import UIKit

import SnapKit

final class PostReplyTextFieldView: UIView {
    
    // MARK: - UI Components
    
    public let horizontalDivierView: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray2
        return view
    }()
    
    public let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .donWhite
        return view
    }()
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = ImageLiterals.Common.imgProfile
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.load(url: loadUserData()?.userProfileImage ?? StringLiterals.Network.baseImageURL)
        image.layer.cornerRadius = 20.adjusted
        return image
    }()
    
    public let greenTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .donPale
        view.layer.cornerRadius = 20.adjusted
        view.isUserInteractionEnabled = true
        return view
    }()
    
    public let replyTextFieldLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donGray8
        label.font = .font(.caption4)
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension PostReplyTextFieldView {
    
    private func setHierarchy() {
        addSubviews(horizontalDivierView, 
                    backgroundView)
        backgroundView.addSubviews(profileImageView, 
                                   greenTextFieldView)
        greenTextFieldView.addSubviews(replyTextFieldLabel)
    }
    
    private func setLayout() {
        horizontalDivierView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.adjusted)
        }
        
        backgroundView.snp.makeConstraints {
            $0.height.equalTo(56.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(horizontalDivierView.snp.bottom)
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(40.adjusted)
            $0.leading.equalTo(16.adjusted)
            $0.centerY.equalToSuperview()
        }
        
        greenTextFieldView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8.adjusted)
            $0.trailing.equalToSuperview().inset(16.adjusted)
            $0.height.equalTo(40.adjusted)
            $0.centerY.equalToSuperview()
        }
        
        replyTextFieldLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(greenTextFieldView.snp.leading).offset(16.adjusted)
        }
    }
}
