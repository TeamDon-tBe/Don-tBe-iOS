//
//  NotificationTableViewCell.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/12/24.
//

import UIKit

import SnapKit

final class NotificationTableViewCell: UITableViewCell, UITableViewCellRegisterable {
        
    // MARK: - UI Components
    
    private let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        return profileImage
    }()
    
    let notificationLabel: UILabel = {
        let notificationLabel = UILabel()
        notificationLabel.textColor = .donGray12
        notificationLabel.font = .font(.body4)
        notificationLabel.numberOfLines = 0  // 여러 줄 지원
        notificationLabel.lineBreakMode = .byCharWrapping
        return notificationLabel
    }()
    
    private let minutes: UILabel = {
        let minutes = UILabel()
        minutes.textColor = .donGray8
        minutes.font = .font(.caption4)
        return minutes
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 13.adjusted, bottom: 4.adjustedH, right: 13.adjusted))
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
        notificationLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(70.adjusted)
            $0.trailing.equalToSuperview().inset(63.adjusted)
        }
        
        minutes.snp.makeConstraints {
            $0.top.equalTo(notificationLabel).offset(2.adjustedH)
            $0.trailing.equalToSuperview().inset(14.adjusted)
            $0.height.equalTo(18.adjusted)
        }
    }
    
    func configureCell(list: NotificationList) {
        profileImage.load(url: list.triggerMemberProfileUrl)
        profileImage.snp.remakeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(14.adjusted)
            $0.size.equalTo(42.adjusted)
        }
        
        switch list.notificationType {
        case .contentLiked, .comment, .commentLiked:
            notificationLabel.text = list.triggerMemberNickname + " " + list.notificationType.description
            notificationLabel.setTextWithLineHeightAndFont(
                text: notificationLabel.text,
                lineHeight: 21.adjusted,
                targetString: list.triggerMemberNickname,
                font: .font(.body3))
        case .actingContinue, .beGhost, .contentGhost, .commentGhost:
            notificationLabel.text = list.memberNickname + " " + list.notificationType.description
            notificationLabel.setTextWithLineHeightAndFont(
                text: notificationLabel.text,
                lineHeight: 21.adjusted,
                targetString: list.memberNickname,
                font: .font(.body3))
        case .userBan:
            notificationLabel.text = list.memberNickname + " " + list.notificationType.description
            notificationLabel.setTextWithLineHeightAndFont(
                text: notificationLabel.text,
                lineHeight: 21.adjusted,
                targetString: list.memberNickname + " " + StringLiterals.Notification.emphasizeViolation,
                font: .font(.body3))
        }
        
        minutes.text = list.time.formattedTime()
    }
}
