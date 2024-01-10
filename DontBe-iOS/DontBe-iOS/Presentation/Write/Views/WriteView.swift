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
    let writeCanclePopupView = DontBePopupView(popupTitle: "",
                                               popupContent: StringLiterals.Write.writePopupContentLabel,
                                               leftButtonTitle: StringLiterals.Write.writePopupCancleButtonTitle,
                                               rightButtonTitle: StringLiterals.Write.writePopupConfirmButtonTitle)
    
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
        
        writeCanclePopupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setAddTarget() {
        
    }
    
    @objc
    private func cancleButtonTapped() {
        writeCanclePopupView.alpha = 0
    }
    
    @objc
    private func postButtonTapped() {
        
    }
}
