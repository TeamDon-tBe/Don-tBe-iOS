//
//  HomeView.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/8/24.
//

import UIKit

final class HomeView: UIView {
    
    // MARK: - UI Components
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray1
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = ImageLiterals.Common.logoSymbol
        return image
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension HomeView {
    
    func setHierarchy() {
        addSubviews(backgroundView)
        backgroundView.addSubviews(logoImageView)
    }
    
    func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(44.adjusted)
            $0.leading.trailing.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12.adjusted)
            $0.width.equalTo(22.adjusted)
            $0.height.equalTo(24.adjusted)
            $0.centerX.equalToSuperview()
        }
    }
}
