//
//  MyPageProfileView.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/11/24.
//

import UIKit

import SnapKit

final class MyPageProfileView: UIView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setCircularImage(image: ImageLiterals.Common.imgProfile)
        return imageView
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.MyPage.icnEditProfile, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let userNickname: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요반가와요우히히"
        label.textColor = .donWhite
        label.textAlignment = .center
        label.font = .font(.head3)
        return label
    }()
    
    private let userIntroduction: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요반가와요우히히안녕하세요반가와요우히히안녕하세요반가와요우히히안녕하세요반가와요우히히히히"
        label.textColor = .donGray7
        label.textAlignment = .center
        label.font = .font(.caption2)
        label.numberOfLines = 2
        return label
    }()
    
    private let percentageBox: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.MyPage.icnPercentageBox
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let transparencyLabel: UILabel = {
        let label = UILabel()
        label.text = "0%"
        label.textColor = .donPrimary
        label.font = .font(.body3)
        return label
    }()
    
    private let emptyTransparencyPercentage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.MyPage.emptyPercentage
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let fullTransparencyPercentage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.MyPage.fullPercentage
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let transparencyInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.MyPage.icnTransparencyInfo, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.frame = CGRect(x: 0, y: 0, width: 12.adjusted, height: 12.adjusted)
        button.setTitle("투명도", for: .normal)
        button.setTitleColor(.donGray6, for: .normal)
        button.titleLabel?.font = .font(.body4)
        button.semanticContentAttribute = .forceRightToLeft // 이미지를 버튼 오른쪽에 표시하도록 설정
        
        var config = UIButton.Configuration.plain()
        config.imagePadding = 4.adjusted
        button.configuration = config
        return button
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

extension MyPageProfileView {
    private func setUI() {
        self.backgroundColor = .donBlack
    }
    
    private func setHierarchy() {
        self.addSubviews(profileImageView,
                         editButton,
                         userNickname,
                         userIntroduction,
                         percentageBox,
                         emptyTransparencyPercentage,
                         fullTransparencyPercentage,
                         transparencyInfoButton)
        
        percentageBox.addSubview(transparencyLabel)
        fullTransparencyPercentage.bringSubviewToFront(emptyTransparencyPercentage)
    }
    
    private func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(12.adjusted)
            $0.size.equalTo(70.adjusted)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top).offset(41.adjusted)
            $0.leading.equalTo(profileImageView.snp.leading).offset(50.adjusted)
            $0.size.equalTo(28.adjusted)
        }
        
        userNickname.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(12.adjusted)
            $0.leading.trailing.equalToSuperview().inset(48.adjusted)
        }
        
        userIntroduction.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userNickname.snp.bottom).offset(8.adjusted)
            $0.leading.trailing.equalToSuperview().inset(32.adjusted)
        }
        
        percentageBox.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.adjusted)
            $0.bottom.equalTo(fullTransparencyPercentage.snp.top).offset(-4.adjusted)
            $0.height.equalTo(28.adjusted)
        }
        
        transparencyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-3.adjusted)
        }
        
        emptyTransparencyPercentage.snp.makeConstraints {
            $0.top.equalTo(userIntroduction.snp.bottom).offset(49.adjusted)
            $0.leading.trailing.equalToSuperview().inset(16.adjusted)
            $0.height.equalTo(10.adjusted)
        }
        
        fullTransparencyPercentage.snp.makeConstraints {
            $0.top.equalTo(userIntroduction.snp.bottom).offset(49.adjusted)
            $0.leading.trailing.equalToSuperview().inset(16.adjusted)
            $0.height.equalTo(10.adjusted)
        }
        
        transparencyInfoButton.snp.makeConstraints {
            $0.top.equalTo(fullTransparencyPercentage.snp.bottom).offset(6.adjusted)
            $0.leading.equalTo(fullTransparencyPercentage.snp.leading).offset(-10.adjusted)
        }
    }
    
    private func setAddTarget() {

    }
    
    private func setRegisterCell() {
        
    }
    
    private func setDataBind() {
        
    }
}
