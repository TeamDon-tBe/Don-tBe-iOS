//
//  PostDetailCollectionFooterView.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/14/24.
//

import UIKit

final class PostDetailCollectionFooterView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "PostReplyCollectionFooterView"
    
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

extension PostDetailCollectionFooterView {
    func setUI() {
        self.backgroundColor = .donGray1
    }
    
    func setHierarchy() {
    }
    
    func setLayout() {
    }
}

