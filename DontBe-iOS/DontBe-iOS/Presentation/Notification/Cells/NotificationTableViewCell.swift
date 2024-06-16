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
    
    var profileButtonAction: (() -> Void) = {}
        
    // MARK: - UI Components
    
    private let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.isUserInteractionEnabled = true
        return profileImage
    }()
    
    var notificationLabel: UILabel = {
        let notificationLabel = UILabel()
        notificationLabel.textColor = .donGray12
        notificationLabel.font = .font(.body4)
        notificationLabel.numberOfLines = 0  // 여러 줄 지원
        notificationLabel.lineBreakMode = .byCharWrapping
        return notificationLabel
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donGray12
        label.font = .font(.body3)
        label.numberOfLines = 0  // 여러 줄 지원
        label.lineBreakMode = .byCharWrapping
        label.isUserInteractionEnabled = true
        return label
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
        setAddTarget()
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
                                     nicknameLabel,
                                     minutes)
        
        self.contentView.bringSubviewToFront(nicknameLabel)
    }
    
    private func setLayout() {
        notificationLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(70.adjusted)
            $0.trailing.equalToSuperview().inset(63.adjusted)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(notificationLabel.snp.top)
            $0.leading.equalTo(notificationLabel.snp.leading)
        }
        
        minutes.snp.makeConstraints {
            $0.top.equalTo(notificationLabel)
            $0.trailing.equalToSuperview().inset(14.adjusted)
            $0.height.equalTo(18.adjusted)
        }
    }
    
    func setAddTarget() {
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileButton)))
        nicknameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileButton)))
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
            nicknameLabel.text = list.triggerMemberNickname
            notificationLabel.text = list.triggerMemberNickname + " " + list.notificationType.description
            notificationLabel.setTextWithLineHeightAndFont(
                text: notificationLabel.text,
                targetString: list.triggerMemberNickname,
                font: .font(.body3))
        case .actingContinue, .beGhost, .contentGhost, .commentGhost:
            nicknameLabel.text = list.memberNickname
            notificationLabel.text = list.memberNickname + " " + list.notificationType.description
            notificationLabel.setTextWithLineHeightAndFont(
                text: notificationLabel.text,
                targetString: list.memberNickname,
                font: .font(.body3))
        case .userBan:
            nicknameLabel.text = list.memberNickname
            notificationLabel.text = list.memberNickname + " " + list.notificationType.description
            notificationLabel.setTextWithLineHeightAndFont(
                text: notificationLabel.text,
                targetString: list.memberNickname,
                font: .font(.body3))
        case .popularWriter:
            nicknameLabel.text = list.memberNickname
            notificationLabel.text = list.memberNickname + " " + list.notificationType.description
            notificationLabel.setTextWithLineHeightAndFont(
                text: notificationLabel.text,
                targetString: list.memberNickname,
                font: .font(.body3))
        case .popularContent:
            nicknameLabel.text = "어제 가장 인기있었던 글이에요.\n"
            notificationLabel.text = ""
        }
        
        minutes.text = list.time.formattedTime()
    }
    
    @objc
    func profileButton() {
        profileButtonAction()
    }
}
