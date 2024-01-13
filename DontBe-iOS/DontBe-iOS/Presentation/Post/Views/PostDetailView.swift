//
//  PostDetailView.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/12/24.
//

import UIKit

import SnapKit

final class PostDetailView: UIView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
        setRegisterCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension PostDetailView {
    private func setUI() {
        self.backgroundColor = .donWhite
    }
    
    private func setHierarchy() {

    }
    
    private func setLayout() {

    }
    
    private func setAddTarget() {

    }
    
    private func setRegisterCell() {
        
    }
    
    private func setDataBind() {
        
    }
}
