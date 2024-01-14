//
//  DontBeBottomSheetButton.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/15/24.
//

import UIKit

import SnapKit

final class DontBeBottomSheetButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String, image: UIImage) {
        super.init(frame: .zero)
        makeImageButton(title: title, image: image)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        makeButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeImageButton(title: String, image: UIImage) {
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20.adjusted)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 20.adjusted, bottom: 0, right: 0)
        setImage(image, for: .normal)
        setTitle(title, for: .normal) // 버튼 타이틀 설정
        titleLabel?.font = .font(.body1) // 버튼 폰트 설정
        backgroundColor = .donGray1 // 버튼 배경색 설정
        setTitleColor(.donBlack, for: .normal) // 버튼 타이틀 컬러 설정
        contentHorizontalAlignment = .left
        contentEdgeInsets.left = 24.adjusted
        layer.cornerRadius = 6.adjusted // 버튼 테두리 corner radius 설정
        self.snp.makeConstraints {
            $0.height.equalTo(60.adjusted)
        }
    }
    
    private func makeButton(title: String) {
        setTitle(title, for: .normal) // 버튼 타이틀 설정
        titleLabel?.font = .font(.body1) // 버튼 폰트 설정
        backgroundColor = .donGray1 // 버튼 배경색 설정
        setTitleColor(.donBlack, for: .normal) // 버튼 타이틀 컬러 설정
        contentHorizontalAlignment = .left
        contentEdgeInsets.left = 24.adjusted
        layer.cornerRadius = 6.adjusted // 버튼 테두리 corner radius 설정
        self.snp.makeConstraints {
            $0.height.equalTo(60.adjusted)
        }
    }
}
