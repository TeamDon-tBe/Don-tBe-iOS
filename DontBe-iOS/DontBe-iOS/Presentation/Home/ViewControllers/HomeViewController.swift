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
    
    var tabBarHeight: CGFloat = 0
    var showUploadToastView: Bool = false
    private var bottomsheet = HomeBottomsheetView()
    
    // MARK: - UI Components
    
    private let myView = HomeView()
    private lazy var homeCollectionView = HomeCollectionView().collectionView
    private let uploadToastView = DontBeToastView()
    
    private let transparentButtonPopupView = DontBePopupView(popupImage: UIImage(named: "transparentPopUp"), popupTitle: StringLiterals.Home.transparentPopupTitleLabel, popupContent: StringLiterals.Home.transparentPopupContentLabel, leftButtonTitle: StringLiterals.Home.transparentPopupLefteftButtonTitle, rightButtonTitle: StringLiterals.Home.transparentPopupRightButtonTitle)
    
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
        setNotification()
    }
    
    // MARK: - TabBar Height
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
    }
}

// MARK: - Extensions

extension HomeViewController {
    private func setUI() {
        self.view.backgroundColor = UIColor.donGray1
        self.navigationController?.navigationBar.isHidden = true
        uploadToastView.alpha = 0
        transparentButtonPopupView.alpha = 0
    }
    
    private func setHierarchy() {
        view.addSubviews(homeCollectionView,
                         uploadToastView,
                         transparentButtonPopupView)
    }
    
    private func setLayout() {
        homeCollectionView.snp.makeConstraints {
            $0.top.equalTo(myView.safeAreaLayoutGuide.snp.top).offset(52.adjusted)
            $0.bottom.equalTo(tabBarHeight)
            $0.width.equalToSuperview()
        }
        
        uploadToastView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.adjusted)
            $0.bottom.equalTo(tabBarHeight).inset(6.adjusted)
            $0.height.equalTo(44)
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
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showToast(_:)), name: WriteViewController.showUploadToastNotification, object: nil)
    }
    
    @objc func showToast(_ notification: Notification) {
        if let showToast = notification.userInfo?["showToast"] as? Bool {
            if showToast == true {
                uploadToastView.alpha = 1
                
                var value: Double = 0.0
                let duration: TimeInterval = 1.0 // 애니메이션 기간 (초 단위)
                let increment: Double = 0.01 // 증가량
                
                // 0에서 1까지 1초 동안 0.01씩 증가하는 애니메이션 블록
                UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
                    for i in 1...100 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + (duration / 100) * TimeInterval(i)) {
                            value = Double(i) * increment
                            self.uploadToastView.circleProgressBar.value = value
                        }
                    }
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.uploadToastView.circleProgressBar.alpha = 0
                    self.uploadToastView.checkImageView.alpha = 1
                    self.uploadToastView.toastLabel.text = StringLiterals.Toast.uploaded
                    self.uploadToastView.container.backgroundColor = .donPrimary
                }
                
                UIView.animate(withDuration: 1.0, delay: 3, options: .curveEaseIn) {
                    self.uploadToastView.alpha = 0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.uploadToastView.circleProgressBar.alpha = 1
                    self.uploadToastView.checkImageView.alpha = 0
                    self.uploadToastView.toastLabel.text = StringLiterals.Toast.uploading
                    self.uploadToastView.container.backgroundColor = .donGray3
                }
            }
        }
    }
}

// MARK: - Network

extension HomeViewController {
    private func getAPI() {
        
    }
}

extension HomeViewController: UICollectionViewDelegate { }

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        HomeCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
        cell.KebabButtonAction = {
            self.bottomsheet.showSettings()
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

extension HomeViewController: DontBePopupDelegate {
    func cancleButtonTapped() {
        transparentButtonPopupView.alpha = 0
    }
    
    func confirmButtonTapped() {
        transparentButtonPopupView.alpha = 0
        // ✅ 투명도 주기 버튼 클릭 시 액션 추가
    }
}
