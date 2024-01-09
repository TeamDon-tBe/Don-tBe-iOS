//
//  HomeViewController.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/8/24.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    var collectionViewBottomHeight: Int = 0
    
    // MARK: - UI Components
    
    private let myView = HomeView()
    private lazy var homeCollectionView = HomeCollectionView().collectionView
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = myView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAPI()
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
    }
    
    // MARK: - TabBar Height
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeAreaHeight = view.safeAreaInsets.bottom
        let tabBarHeight: CGFloat = 70.0
        collectionViewBottomHeight = Int(tabBarHeight + safeAreaHeight)
    }
}

// MARK: - Extensions

extension HomeViewController {
    func setUI() {
        self.view.backgroundColor = UIColor.donGray1
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setHierarchy() {
        view.addSubviews(homeCollectionView)
    }
    
    func setLayout() {
        homeCollectionView.snp.makeConstraints {
            $0.top.equalTo(myView.safeAreaLayoutGuide.snp.top).offset(52)
            $0.bottom.equalTo(collectionViewBottomHeight)
            $0.width.equalToSuperview()
        }
    }
    
    func setDelegate() {
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
    }
}

// MARK: - Network

extension HomeViewController {
    func getAPI() {
        
    }
}

extension HomeViewController: UICollectionViewDelegate { }

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        HomeCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 343.adjusted, height: 232.adjusted)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = homeCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeCollectionFooterView", for: indexPath) as? HomeCollectionFooterView else { return UICollectionReusableView() }
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {

        return CGSize(width: UIScreen.main.bounds.width, height: 44)
        
    }
}
