//
//  MyPageAccountInfoTableViewCell.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/14/24.
//

import UIKit

import SnapKit

final class MyPageAccountInfoTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MyPageAccountInfoTableViewCell"
    
    // MARK: - UI Components
    
    let infoTitle: UILabel = {
        let label = UILabel()
        label.font = .font(.body3)
        label.textColor = .donBlack
        return label
    }()
    
    let infoContent: UILabel = {
        let label = UILabel()
        label.font = .font(.body4)
        label.textColor = .donGray7
        return label
    }()
    
    // MARK: - Life Cycles

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
    }

    required init?(coder: NSCoder) {
        fatalError("")
    }
}

// MARK: - Extensions

extension MyPageAccountInfoTableViewCell {
    func setUI() {
        
    }
    
    func setHierarchy() {
        self.addSubviews(infoTitle,
                         infoContent)
    }
    
    func setLayout() {
        infoTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16.adjusted)
        }
        
        infoContent.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15.adjusted)
        }
    }
    
    func setAddTarget() {
        
    }
}
