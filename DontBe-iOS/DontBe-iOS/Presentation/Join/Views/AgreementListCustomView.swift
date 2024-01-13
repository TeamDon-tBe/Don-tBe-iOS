//
//  CutomView.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/10/24.
//

import UIKit

import SnapKit

final class AgreementListCustomView: UIView {
    
    let checkButton: UIButton = {
        let checkButton = UIButton()
        checkButton.setImage(ImageLiterals.Join.btnNotCheckBox, for: .normal)
        return checkButton
    }()
    
    let infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.textColor = .donBlack
        infoLabel.font = .font(.body2)
        return infoLabel
    }()
    
    let necessaryOrSelectImage = UIImageView()
    
    let moreButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(title: String, subImage: UIImage? = nil, moreImage: UIImage? = ImageLiterals.Join.btnView) {
        super.init(frame: .zero)
        
        infoLabel.text = title
        necessaryOrSelectImage.image = subImage
        moreButton.setImage(moreImage, for: .normal)
        
        self.addSubviews(checkButton,
                         infoLabel,
                         necessaryOrSelectImage,
                         moreButton)
        
        checkButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.size.equalTo(32.adjusted)
        }
        
        infoLabel.snp.makeConstraints {
            $0.leading.equalTo(checkButton.snp.trailing).offset(7.adjusted)
            $0.centerY.equalTo(checkButton)
        }
        
        necessaryOrSelectImage.snp.makeConstraints {
            $0.leading.equalTo(infoLabel.snp.trailing).offset(4.adjusted)
            $0.centerY.equalTo(infoLabel)
            $0.width.equalTo(33.adjusted)
            $0.height.equalTo(18.adjusted)
        }
        
        moreButton.snp.makeConstraints {
            $0.leading.equalTo(necessaryOrSelectImage.snp.trailing).offset(6.adjusted)
            $0.centerY.equalTo(infoLabel)
            $0.width.equalTo(23.adjusted)
            $0.height.equalTo(24.adjusted)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
