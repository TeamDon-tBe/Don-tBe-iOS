//
//  NotificationTableViewCell.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/12/24.
//

import UIKit

import SnapKit

final class NotificationTableViewCell: UITableViewCell, UITableViewCellRegisterable {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let profileImage = UIImageView()
    private var notificationLabel: UILabel = {
        let description = UILabel()
        description.textColor = .donGray12
        description.font = .font(.body4)
        return description
    }()
    private let minutes: UILabel = {
        let minutes = UILabel()
        minutes.textColor = .donGray8
        minutes.font = .font(.caption4)
        return minutes
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 13.adjusted, bottom: 4.adjusted, right: 13.adjusted))
    }
    
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
    
    
    func configureCell(item: NotificationDummy) {
        profileImage.setCircularImage(image: item.profile)
        notificationLabel.text = item.userName + " " + item.description
        minutes.text = item.minutes
    }
}


// MARK: - Extensions

extension NotificationTableViewCell {
    private func setUI() {
        self.backgroundColor = .donGray1
        self.contentView.backgroundColor = .donWhite
        self.contentView.layer.cornerRadius = 8.adjusted
        self.contentView.layer.masksToBounds = true
    }
    
    private func setHierarchy() {
        self.contentView.addSubviews(profileImage, 
                                     notificationLabel,
                                     minutes)
    }
    
    private func setLayout() {
        profileImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.leading.equalToSuperview().inset(14.adjusted)
            $0.size.equalTo(42.adjusted)
        }
        
        notificationLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImage.snp.trailing).offset(14.adjusted)
            $0.trailing.equalTo(minutes.snp.leading).offset(-14.adjusted)
        }
        
        minutes.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(14.adjusted)
        }
    }
}
