//
//  PostReplyCollectionView.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/12/24.
//

import UIKit

final class PostReplyCollectionView: UIView {
    
    // MARK: - UI Components
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10.adjusted
        flowLayout.minimumInteritemSpacing = 10.adjusted
        flowLayout.scrollDirection = .vertical
        flowLayout.estimatedItemSize = CGSize(width: 200.adjusted, height: 160.adjusted)

        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isUserInteractionEnabled = true
        collectionView.allowsSelection = true
        collectionView.backgroundColor = .donGray1
        
        return collectionView
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setRegisterCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

private extension PostReplyCollectionView {
    func setHierarchy() {
        addSubviews(collectionView)
    }
    
    func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setRegisterCell() {
        PostReplyCollectionViewCell.register(collectionView: collectionView)
        collectionView.register(PostReplyCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "PostReplyCollectionFooterView")
        collectionView.register(PostCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PostCollectionViewHeader")
    }
}
