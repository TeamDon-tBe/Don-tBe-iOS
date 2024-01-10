//
//  CutomView.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/10/24.
//

import UIKit

import SnapKit

final class CustomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(title: String, subImage: UIImage? = nil, moreImage: UIImage? = ImageLiterals.Join.btnView) {
        super.init(frame: .zero)
        
        let checkImage: UIImageView = {
            let checkImage = UIImageView()
            checkImage.image = ImageLiterals.Join.btnNotCheckBox
            return checkImage
        }()
        
        let infoLabel: UILabel = {
            let infoLabel = UILabel()
            infoLabel.text = title
            infoLabel.textColor = .donBlack
            infoLabel.font = .font(.body2)
            return infoLabel
        }()
        
        let necessaryOrSelectButton: UIButton = {
            let necessaryOrSelectButton = UIButton()
            necessaryOrSelectButton.setImage(subImage, for: .normal)
            return necessaryOrSelectButton
        }()
        
        let moreButton: UIButton = {
            let moreButton = UIButton()
            moreButton.setImage(moreImage, for: .normal)
            return moreButton
        }()
        
        self.addSubviews(checkImage,
                         infoLabel,
                         necessaryOrSelectButton,
                         moreButton)
        
        checkImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.size.equalTo(24.adjusted)
        }
        
        infoLabel.snp.makeConstraints {
            $0.leading.equalTo(checkImage.snp.trailing).offset(11.adjusted)
            $0.centerY.equalTo(checkImage)
        }
        
        necessaryOrSelectButton.snp.makeConstraints {
            $0.leading.equalTo(infoLabel.snp.trailing).offset(4.adjusted)
            $0.centerY.equalTo(infoLabel)
            $0.width.equalTo(33.adjusted)
            $0.height.equalTo(18.adjusted)
        }
        
        moreButton.snp.makeConstraints {
            $0.leading.equalTo(necessaryOrSelectButton.snp.trailing).offset(6.adjusted)
            $0.centerY.equalTo(infoLabel)
            $0.width.equalTo(23.adjusted)
            $0.height.equalTo(24.adjusted)
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
