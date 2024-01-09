//
//  CustomButton.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/9/24.
//

import UIKit

import SnapKit

final class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String, backColor: UIColor, titleColor: UIColor) {
        super.init(frame: .zero)
        setTitle(title, for: .normal) // 버튼 타이틀 설정
        titleLabel?.font = .font(.body3) // 버튼 폰트 설정
        backgroundColor = backColor // 버튼 배경색 설정
        setTitleColor(titleColor, for: .normal) // 버튼 타이틀 컬러 설정
        layer.cornerRadius = 6.adjusted // 버튼 테두리 corner radius 설정
        self.snp.makeConstraints {
            $0.width.equalTo(342.adjusted)
            $0.height.equalTo(50.adjusted)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
