//
//  CustomButton.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/9/24.
//

import UIKit

final class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal) // 버튼의 타이틀 설정
        titleLabel?.font = .font(.body3)
        backgroundColor = .donBlack
        setTitleColor(.white, for: .normal) // 타이틀 컬러 설정
        layer.cornerRadius = 6 // 테두리 곡률 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
