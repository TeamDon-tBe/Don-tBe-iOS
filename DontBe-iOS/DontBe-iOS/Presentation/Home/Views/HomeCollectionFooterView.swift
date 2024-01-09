//
//  HomeCollectionFooterView.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/9/24.
//

import UIKit

final class HomeCollectionFooterView: UICollectionReusableView {
    
    // MARK: - Properties
    static let identifier = "HomeCollectionFooterView"
    
    // MARK: - UI Components
    private let storeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .green
        label.text = "ㅎㅇㅎㅇㅎㅇㅎㅇ"
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.clear.cgColor
        image.image = ImageLiterals.Common.logoSymbol
        return image
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
extension HomeCollectionFooterView {
    func setUI() {
        self.backgroundColor = .donGray1
    }
    
    func setHierarchy() {
        self.addSubviews(storeNameLabel)
    }
    
    func setLayout() {
        print("얍")
        storeNameLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(12)
            $0.leading.equalTo(15)
        }
    }
}
