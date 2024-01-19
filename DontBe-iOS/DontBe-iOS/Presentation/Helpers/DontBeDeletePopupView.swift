//
//  DontBeDeletePopupView.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/19/24.
//

import UIKit

import SnapKit

final class DontBeDeletePopupView: UIView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray3
        view.layer.cornerRadius = 10.adjusted
        return view
    }()
    
    let toastLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.Toast.deleteText
        label.textColor = .donBlack
        label.textAlignment = .center
        label.font = UIFont.font(.head3)
        return label
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

extension DontBeDeletePopupView {
    
    private func setHierarchy() {
        self.addSubview(container)
        container.addSubviews(toastLabel)
    }
    
    private func setLayout() {
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        toastLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
