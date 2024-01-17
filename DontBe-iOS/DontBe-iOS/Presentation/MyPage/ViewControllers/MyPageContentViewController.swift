//
//  MyPageContentViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/11/24.
//

import Combine
import UIKit

import SnapKit

final class MyPageContentViewController: UIViewController {
    
    // MARK: - Properties
    
    var showUploadToastView: Bool = false
    var deleteBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnDelete)
    private let refreshControl = UIRefreshControl()
    
    private var cancelBag = CancelBag()
    
    var profileData: [MypageProfileResponseDTO] = []
    var contentData: [MyPageMemberContentResponseDTO] = []
    
    // MARK: - UI Components
    
    lazy var homeCollectionView = HomeCollectionView().collectionView
    var noContentLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.MyPage.myPageNoContentLabel
        label.textColor = .donGray7
        label.font = .font(.body2)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let firstContentButton: UIButton = {
        let button = UIButton()
        button.setTitle(StringLiterals.MyPage.myPageNoContentButton, for: .normal)
        button.setTitleColor(.donSecondary, for: .normal)
        button.titleLabel?.font = .font(.body2)
        button.backgroundColor = .donPale
        button.layer.cornerRadius = 4.adjusted
        button.layer.borderWidth = 1.adjusted
        button.layer.borderColor = UIColor.donSecondary.cgColor
        return button
    }()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
}

// MARK: - Extensions

extension MyPageContentViewController {
    private func setUI() {
        self.view.backgroundColor = UIColor.donGray1
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setHierarchy() {
        view.addSubviews(homeCollectionView, noContentLabel, firstContentButton)
    }
    
    private func setLayout() {
        homeCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        noContentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(44.adjusted)
            $0.leading.trailing.equalToSuperview().inset(20.adjusted)
        }
        
        firstContentButton.snp.makeConstraints {
            $0.top.equalTo(noContentLabel.snp.bottom).offset(20.adjusted)
            $0.leading.trailing.equalToSuperview().inset(112.adjusted)
            $0.height.equalTo(44.adjusted)
        }
    }
    
    private func setDelegate() {
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
    }
    
    private func setRefreshControll() {
        refreshControl.addTarget(self, action: #selector(refreshPost), for: .valueChanged)
        homeCollectionView.refreshControl = refreshControl
        refreshControl.backgroundColor = .donGray1
    }
    
    @objc
    func refreshPost() {
        DispatchQueue.main.async {
            self.homeCollectionView.reloadData()
        }
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
        let sortedData = contentData.sorted { $0.time.compare($1.time, options: .numeric) == .orderedDescending }
        
        self.contentData = sortedData
        return self.contentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        HomeCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
        
        if contentData[indexPath.row].memberId == loadUserData()?.memberId {
            cell.ghostButton.isHidden = true
            cell.verticalTextBarView.isHidden = true
        } else {
            cell.ghostButton.isHidden = false
            cell.verticalTextBarView.isHidden = false
        }
        cell.nicknameLabel.text = contentData[indexPath.row].memberNickname
        cell.transparentLabel.text = "투명도 \(contentData[indexPath.row].memberGhost)%"
        cell.timeLabel.text = "\(contentData[indexPath.row].time.formattedTime())"
        cell.contentTextLabel.text = contentData[indexPath.row].contentText
        cell.likeNumLabel.text = "\(contentData[indexPath.row].likedNumber)"
        cell.commentNumLabel.text = "\(contentData[indexPath.row].commentNumber)"
        cell.profileImageView.load(url: "\(contentData[indexPath.row].memberProfileUrl)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationViewController = PostViewController()
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 343.adjusted, height: 210.adjusted)
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard let footer = homeCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeCollectionFooterView", for: indexPath) as? HomeCollectionFooterView else { return UICollectionReusableView() }
//        return footer
//    }
    
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
//        transparentButtonPopupView.alpha = 0
    }
    
    func confirmButtonTapped() {
//        transparentButtonPopupView.alpha = 0
        // ✅ 투명도 주기 버튼 클릭 시 액션 추가
    }
}
