//
//  DontBeCustomInfoView.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/12/24.
//

import UIKit

import SnapKit

final class DontBeCustomInfoView: UIView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    let InfoImage: UIImageView = {
        let image = UIImageView()
        image.image = ImageLiterals.TransparencyInfo.imgTransparencyInfo1
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.text = StringLiterals.TransparencyInfo.title1
        title.textColor = .donBlack
        title.font = .font(.head3)
        title.textAlignment = .center
        title.numberOfLines = 2
        return title
    }()
    
    let content: UILabel = {
        let content = UILabel()
        content.text = StringLiterals.TransparencyInfo.content1
        content.textColor = .donGray12
        content.font = .font(.body4)
        content.textAlignment = .center
        content.numberOfLines = 2
        return content
    }()
    
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

extension DontBeCustomInfoView {
    private func setUI() {
        self.backgroundColor = .clear
    }
    
    private func setHierarchy() {
        self.addSubviews(InfoImage,
                         title,
                         content)
    }
    
    private func setLayout() {
        InfoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(27.adjusted)
            $0.height.equalTo(159.adjusted)
        }
        
        title.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(content.snp.top).offset(-18.adjusted)
        }
        
        content.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(28.adjusted)
            $0.bottom.equalToSuperview().inset(44.adjusted)
        }
    }
}

