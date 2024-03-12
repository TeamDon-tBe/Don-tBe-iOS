//
//  WriteReplyContentView.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/14/24.
//

import UIKit

import SnapKit

final class WriteReplyContentView: UIView {

    // MARK: - Properties
    var detailViewHeight: Int = 0
    
    // MARK: - UI Components
    
    private let backgroundUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .donWhite
        return view
    }()
    
    var profileImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 22.adjusted
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    
    var postNicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donBlack
        label.text = ""
        label.font = .font(.body3)
        return label
    }()
    
    public let contentTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donBlack
        label.text = ""
        label.lineBreakMode = .byCharWrapping
        label.font = .font(.body4)
        label.numberOfLines = 0
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

extension WriteReplyContentView {
    
    private func setHierarchy() {
        addSubviews(backgroundUIView)
        
        backgroundUIView.addSubviews(profileImageView,
                                     postNicknameLabel,
                                     contentTextLabel)
    }
    
    private func setLayout() {
        backgroundUIView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(10.adjusted)
            $0.top.equalTo(18.adjusted)
            $0.size.equalTo(44.adjusted)
        }
        
        postNicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8.adjusted)
            $0.top.equalTo(profileImageView.snp.top).offset(4.adjusted)
        }
        
        contentTextLabel.snp.makeConstraints {
            $0.top.equalTo(postNicknameLabel.snp.bottom).offset(6.adjusted)
            $0.leading.equalTo(postNicknameLabel)
            $0.trailing.equalToSuperview().inset(20.adjusted)
        }
    }
    
    private func saveHeight() {
        detailViewHeight = Int(self.backgroundUIView.frame.height)
    }
}

