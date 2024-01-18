//
//  WriteReplyPostView.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/14/24.
//

import UIKit

import SnapKit

final class WriteReplyPostView: UIView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let backgroundUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .donWhite
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 22.adjusted
        image.image = ImageLiterals.Onboarding.imgOne
        return image
    }()
    
    var postNicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donBlack
        label.text = "Don't be야 사랑해~"
        label.font = .font(.body3)
        return label
    }()
    
    public let contentTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donBlack
        label.text = "돈비를 사용하면 진짜 돈비를 맞을 수 있나요? 저 돈비 맞고 싶어요 돈벼락이 최고입니다.돈비를 사용하면 진짜 돈비를 맞을 수 있나요? 저 돈비 맞고 싶어요 돈벼락이 최고입니다."
        label.lineBreakMode = .byCharWrapping
        label.font = .font(.body4)
        label.numberOfLines = 0
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

extension WriteReplyPostView {
    private func setUI() {
        
    }
    
    private func setHierarchy() {
        addSubviews(backgroundUIView)
        backgroundUIView.addSubviews(profileImageView,
                                     postNicknameLabel,
                                     contentTextLabel)
    }
    
    private func setLayout() {
        backgroundUIView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
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
        
        contentTextLabel.snp.makeConstraints {
            $0.top.equalTo(postNicknameLabel.snp.bottom).offset(6.adjusted)
            $0.leading.equalTo(postNicknameLabel)
            $0.trailing.equalToSuperview().inset(20.adjusted)
        }
    }
    
    private func setAddTarget() {

    }
    
    private func setRegisterCell() {
        
    }
    
    private func setDataBind() {
        
    }
}

