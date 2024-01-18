//
//  WriteBanView.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/18/24.
//

import UIKit

import SnapKit

final class WriteBanView: UIView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let backGroundImage: UIImageView = {
       let backGroundImage = UIImageView()
        backGroundImage.backgroundColor = .donWhite
        backGroundImage.layer.cornerRadius = 10.adjusted
        backGroundImage.layer.masksToBounds = true
        backGroundImage.isUserInteractionEnabled = true
        return backGroundImage
    }()
    
    private let banImage: UIImageView = {
        let banImage = UIImageView()
        banImage.image = ImageLiterals.Write.imgWritingRestriction
        return banImage
    }()
    
    private let banTitle: UIImageView = {
        let banTitle = UIImageView()
        banTitle.image = ImageLiterals.Write.imgBanText
        banTitle.contentMode = .scaleAspectFit
        return banTitle
    }()
    
    let promiseButton = CustomButton(title: StringLiterals.Button.promise, backColor: .donBlack, titleColor: .donWhite)
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension WriteBanView {
    private func setUI() {
        self.backgroundColor = .donBlack.withAlphaComponent(0.6)
    }
    
    private func setHierarchy() {
        self.addSubviews(backGroundImage)
        backGroundImage.addSubviews(banImage, banTitle, promiseButton)
    }
    
    private func setLayout() {
        
        backGroundImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(327.adjusted)
            $0.height.equalTo(360.adjusted)
        }
        
        banImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(36.adjusted)
            $0.leading.equalToSuperview().inset(110.adjusted)
            $0.width.equalTo(147.adjusted)
            $0.height.equalTo(125.adjusted)
        }
        
        banTitle.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(88.adjusted)
            $0.leading.trailing.equalToSuperview().inset(20.adjusted)
        }
        
        promiseButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20.adjusted)
            $0.leading.trailing.equalToSuperview().inset(20.adjusted)
        }
        
    }
}
