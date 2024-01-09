//
//  BackButton.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/9/24.
//

import UIKit

import SnapKit

final class BackButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init() {
        super.init(frame: .zero)
        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        setImage(ImageLiterals.Common.btnBack, for: .normal)
        self.snp.makeConstraints {
            $0.size.equalTo(24.adjusted)
        }
    }
}
