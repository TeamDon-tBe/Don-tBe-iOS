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
    var postView = PostView()
    
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
        
    }
    
    private func setHierarchy() {
        addSubviews(postView)
    }
    
    private func setLayout() {
        postView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setAddTarget() {

    }
    
    private func setRegisterCell() {
        
    }
    
    private func setDataBind() {
        
    }
}
