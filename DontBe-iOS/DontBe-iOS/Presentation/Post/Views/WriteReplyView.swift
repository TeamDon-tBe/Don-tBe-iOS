//
//  WriteReplyView.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/14/24.
//

import UIKit

import SnapKit

final class WriteReplyView: UIView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    private lazy var writeReplyPostview = WriteReplyPostView()
    private lazy var writeReplyView = WriteReplyEditorView()
    
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

extension WriteReplyView {
    private func setUI() {
        
    }
    
    private func setHierarchy() {
        addSubviews(writeReplyPostview,
                    writeReplyView)
    }
    
    private func setLayout() {
        writeReplyPostview.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        writeReplyView.snp.makeConstraints {
            $0.top.equalTo(writeReplyPostview.contentTextLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func setAddTarget() {

    }
    
    private func setRegisterCell() {
        
    }
    
    private func setDataBind() {
        
    }
}
