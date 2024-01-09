//
//  HomeCollectionViewCell.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/8/24.
//

import UIKit

final class HomeCollectionViewCell: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    private let backgroundUIView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.donWhite
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.clear.cgColor
        image.image = UIImage.checkmark
        return image
    }()
    
    private let storeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .green
        label.text = "ㅎㅇㅎㅇㅎㅇㅎㅇ"
        return label
    }()
    
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
}

// MARK: - Extensions

extension HomeCollectionViewCell {
    func setUI() {
    }
    
    func setHierarchy() {
        contentView.addSubviews(backgroundUIView)
        backgroundUIView.addSubviews(profileImageView, storeNameLabel)
    }
    
    func setLayout() {
        backgroundUIView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(10)
            $0.top.equalTo(18)
            $0.size.equalTo(44)
        }
        storeNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.top.equalTo(24)
        }
    }
}
