//
//  WriteView.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/8/24.
//

import UIKit

import SnapKit

final class WriteView: UIView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    let writeTextView = WriteTextView()
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension WriteView {
    func setUI() {
        self.backgroundColor = .donWhite
        writeTextView.layer.borderColor = UIColor.donGray2.cgColor
        writeTextView.layer.borderWidth = 1
        writeCanclePopupView.alpha = 0
    }
    
    func setHierarchy() {
        self.addSubviews(writeTextView, writeCanclePopupView)
    }
    
    func setLayout() {
        writeTextView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setAddTarget() {

    }
    
    @objc
    func buttonTapped() {
        
        writeTextView.postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
    }
    
    func setRegisterCell() {
        
    }
    
    @objc
    private func postButtonTapped() {
        
    }
}