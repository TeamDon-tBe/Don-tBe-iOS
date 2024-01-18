//
//  DontBeTransparencyGrayView.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/18/24.
//

import UIKit

import SnapKit

final class DontBeTransparencyGrayView: UIView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
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

extension DontBeTransparencyGrayView {
    private func setUI() {
        self.backgroundColor = .donGray1
    }
    
    private func setHierarchy() {
        
    }
    
    private func setLayout() {
        
    }
}

