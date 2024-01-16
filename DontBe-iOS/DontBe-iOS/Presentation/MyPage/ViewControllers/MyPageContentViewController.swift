//
//  MyPageContentViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/11/24.
//

import UIKit

import SnapKit

final class MyPageContentViewController: UIViewController {
    
    // MARK: - Properties
    
    var showUploadToastView: Bool = false
    var deleteBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnDelete)
    private let refreshControl = UIRefreshControl()
    
    // MARK: - UI Components
    
    lazy var homeCollectionView = HomeCollectionView().collectionView
    
    private let transparentButtonPopupView = DontBePopupView(popupImage: ImageLiterals.Popup.transparentButtonImage,
                                                             popupTitle: StringLiterals.Home.transparentPopupTitleLabel,
                                                             popupContent: StringLiterals.Home.transparentPopupContentLabel,
                                                             leftButtonTitle: StringLiterals.Home.transparentPopupLefteftButtonTitle,
                                                             rightButtonTitle: StringLiterals.Home.transparentPopupRightButtonTitle)
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAPI()
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        setRefreshControll()
    }
}

// MARK: - Extensions

extension MyPageContentViewController {
    private func setUI() {
        self.view.backgroundColor = UIColor.donGray1
        self.navigationController?.navigationBar.isHidden = true
        transparentButtonPopupView.alpha = 0
    }
    
    private func setHierarchy() {
        view.addSubviews(homeCollectionView,
                         transparentButtonPopupView)
    }
    
    private func setLayout() {
        homeCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
        
        transparentButtonPopupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        transparentButtonPopupView.delegate = self
    }
    
    private func setRefreshControll() {
        refreshControl.addTarget(self, action: #selector(refreshPost), for: .valueChanged)
        homeCollectionView.refreshControl = refreshControl
        refreshControl.backgroundColor = .donGray1
    }
    
    @objc
    func refreshPost() {
        DispatchQueue.main.async {
            // ✅ 서버 통신 영역
            //
        }
        self.homeCollectionView.reloadData()
        self.perform(#selector(self.finishedRefreshing), with: nil, afterDelay: 0.1)
    }
      
    @objc
    func finishedRefreshing() {
        refreshControl.endRefreshing()
    }
    
}

// MARK: - Network

extension MyPageContentViewController {
    private func getAPI() {
        
    }
}

extension MyPageContentViewController: UICollectionViewDelegate { }

extension MyPageContentViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        HomeCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
        cell.KebabButtonAction = {
            self.deleteBottomsheet.showSettings()
        }
        cell.LikeButtonAction = {
            cell.isLiked.toggle()
            cell.likeButton.setImage(cell.isLiked ? ImageLiterals.Posting.btnFavoriteActive : ImageLiterals.Posting.btnFavoriteInActive, for: .normal)
        }
        cell.TransparentButtonAction = {
            self.transparentButtonPopupView.alpha = 1
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 343.adjusted, height: 210.adjusted)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = homeCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeCollectionFooterView", for: indexPath) as? HomeCollectionFooterView else { return UICollectionReusableView() }
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 24.adjusted)
    }
}

extension MyPageContentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if yOffset > 0 {
            scrollView.isScrollEnabled = true
        } else if yOffset < 0 {
            scrollView.isScrollEnabled = false
        }
    }
}

extension MyPageContentViewController: DontBePopupDelegate {
    func cancleButtonTapped() {
        transparentButtonPopupView.alpha = 0
    }
    
    func confirmButtonTapped() {
        transparentButtonPopupView.alpha = 0
        // ✅ 투명도 주기 버튼 클릭 시 액션 추가
    }
}
