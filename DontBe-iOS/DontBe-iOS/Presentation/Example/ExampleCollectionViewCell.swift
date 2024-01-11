//
//  ExampleCollectionViewCell.swift
//  DontBe-iOS
//
//  Created by 변상우 on 12/26/23.
//

import UIKit

final class ExampleCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UITableViewCell인 경우
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        setUI()
//        setHierarchy()
//        setLayout()
//    }
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}

// MARK: - Extensions

extension ExampleCollectionViewCell {
    private func setUI() {
        
    }
    
    private func setHierarchy() {
        
    }
    
    private func setLayout() {
        
    }
}
