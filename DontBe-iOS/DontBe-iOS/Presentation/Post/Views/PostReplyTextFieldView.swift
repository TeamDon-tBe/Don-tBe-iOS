//
//  PostReplyTextFieldView.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/13/24.
//

import UIKit

import SnapKit

final class PostReplyTextFieldView: UIView {

    // MARK: - Properties
    
    
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
    
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = ImageLiterals.Onboarding.imgTwo
        image.backgroundColor = .lightGray
        image.layer.cornerRadius = 20.adjusted
        return image
    }()
    
    private let textFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .donPale
        view.layer.cornerRadius = 20.adjusted
        return view
    }()
    
    public let replyTextFieldLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donGray8
        label.font = .font(.caption4)
        label.numberOfLines = 0
        label.text = "하이"
        return label
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

extension PostReplyTextFieldView {
    private func setUI() {
        
    }
    
    private func setHierarchy() {
        addSubviews(horizontalDivierView, backgroundView)
        backgroundView.addSubviews(profileImageView, textFieldView)
        textFieldView.addSubviews(replyTextFieldLabel)
    }
    
    private func setLayout() {
        horizontalDivierView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(1.adjusted)
        }
        
        backgroundView.snp.makeConstraints {
            $0.height.equalTo(56.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(horizontalDivierView.snp.bottom)
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(40.adjusted)
            $0.leading.equalTo(16)
            $0.centerY.equalToSuperview()
        }
        
        textFieldView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
            $0.centerY.equalToSuperview()
        }
        
        replyTextFieldLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(textFieldView.snp.leading).offset(16)
        }
        
    }
    
    private func setAddTarget() {

    }
    
    private func setRegisterCell() {
        
    }
    
    private func setDataBind() {
        
    }
}
