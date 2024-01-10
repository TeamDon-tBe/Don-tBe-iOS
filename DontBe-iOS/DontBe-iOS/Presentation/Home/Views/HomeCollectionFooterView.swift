//
//  HomeCollectionFooterView.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/9/24.
//

import UIKit

final class HomeCollectionFooterView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "HomeCollectionFooterView"
    
    // MARK: - UI Components
    
    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
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

extension HomeCollectionFooterView {
    func setUI() {
        self.backgroundColor = .donGray1
    }
    
    func setHierarchy() {
        self.addSubviews(footerView)
    }
    
    func setLayout() {
        footerView.snp.makeConstraints {
            $0.height.equalTo(2.adjusted)
            
        }
    }
}
