//
//  DontBePopupReasonListCustomView.swift
//  DontBe-iOS
//
//  Created by 변상우 on 2/27/24.
//

import UIKit

import SnapKit

final class DontBePopupReasonListCustomView: UIView {
    
    let radioButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.TransparencyInfo.btnRadio, for: .normal)
        return button
    }()
    
    let reasonLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.textColor = .donBlack
        infoLabel.font = .font(.body2)
        return infoLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(reason: String) {
        super.init(frame: .zero)
        
        reasonLabel.text = reason
        
        self.addSubviews(radioButton,
                         reasonLabel)
        
        radioButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(22.adjusted)
            $0.size.equalTo(30.adjusted)
        }
        
        reasonLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(radioButton.snp.trailing).offset(4.adjusted)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
