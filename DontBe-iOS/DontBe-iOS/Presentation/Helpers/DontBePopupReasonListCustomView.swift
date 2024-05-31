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
        button.setTitleColor(.donBlack, for: .normal)
        button.titleLabel?.font = .font(.body4)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4.adjusted, bottom: 2.adjusted, right: -4.adjusted)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(reason: String) {
        super.init(frame: .zero)
        
        radioButton.setTitle(reason, for: .normal)
        
        self.addSubviews(radioButton)
        
        radioButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(22.adjusted)
            $0.height.equalTo(30.adjusted)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
