//
//  NotificationEmptyViewCell.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/12/24.
//

import UIKit

import SnapKit

final class NotificationEmptyViewCell: UITableViewCell, UITableViewCellRegisterable {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let emptyImage: UIImageView = {
        let emptyImage = UIImageView()
        emptyImage.image = ImageLiterals.Notification.imgEmpty
        return emptyImage
    }()
    
    private let emptyTitle: UILabel = {
        let emptyTitle = UILabel()
        emptyTitle.text = StringLiterals.Notification.emptyTitle
        emptyTitle.textColor = .donGray12
        emptyTitle.font = .font(.body3)
        return emptyTitle
    }()
    
    private let emptyDescirption: UILabel = {
        let emptyDescirption = UILabel()
        emptyDescirption.text = StringLiterals.Notification.emptyDescription
        emptyDescirption.textColor = .donGray9
        emptyDescirption.font = .font(.caption2)
        return emptyDescirption
    }()
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

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

extension NotificationEmptyViewCell {
    private func setUI() {
        self.backgroundColor = .donGray1
    }
    
    private func setHierarchy() {
        self.addSubviews(emptyImage,
                         emptyTitle,
                         emptyDescirption)
    }
    
    private func setLayout() {
        emptyImage.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(177.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(77.adjusted)
            $0.height.equalTo(90.adjusted)
        }
        
        emptyTitle.snp.makeConstraints {
            $0.top.equalTo(emptyImage.snp.bottom).offset(24.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        emptyDescirption.snp.makeConstraints {
            $0.top.equalTo(emptyTitle.snp.bottom).offset(4.adjustedH)
            $0.centerX.equalToSuperview()
        }
    }
}
