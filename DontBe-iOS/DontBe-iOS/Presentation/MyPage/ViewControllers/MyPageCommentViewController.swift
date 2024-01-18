//
//  MyPageCommentViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/11/24.
//

import Combine
import UIKit

import SnapKit

final class MyPageCommentViewController: UIViewController {
    
    // MARK: - Properties
    
    var showUploadToastView: Bool = false
    var deleteBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnDelete)
    private let refreshControl = UIRefreshControl()
    
    var profileData: [MypageProfileResponseDTO] = []
    var commentData: [MyPageMemberCommentResponseDTO] = []
    
    // MARK: - UI Components
    
    lazy var homeCollectionView = HomeCollectionView().collectionView
    let noCommentLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.MyPage.myPageNoCommentLabel
        label.textColor = .donGray7
        label.font = .font(.body2)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
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
}

// MARK: - Extensions

extension MyPageCommentViewController {
    private func setUI() {
        self.view.backgroundColor = UIColor.donGray1
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setHierarchy() {
        view.addSubviews(homeCollectionView, noCommentLabel)
    }
    
    private func setLayout() {
        homeCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        noCommentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(44.adjusted)
            $0.leading.trailing.equalToSuperview().inset(20.adjusted)
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

extension MyPageCommentViewController {
    private func getAPI() {
        
    }
}

extension MyPageCommentViewController: UICollectionViewDelegate { }

extension MyPageCommentViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sortedData = commentData.sorted { $0.time.compare($1.time, options: .numeric) == .orderedDescending }
        
        commentData = sortedData
        return commentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        HomeCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
        if commentData[indexPath.row].memberId == loadUserData()?.memberId {
            cell.ghostButton.isHidden = true
            cell.verticalTextBarView.isHidden = true
        } else {
            cell.ghostButton.isHidden = false
            cell.verticalTextBarView.isHidden = false
        }
        cell.nicknameLabel.text = commentData[indexPath.row].memberNickname
        cell.transparentLabel.text = "투명도 \(commentData[indexPath.row].memberGhost)%"
        cell.timeLabel.text = "\(commentData[indexPath.row].time.formattedTime())"
        cell.contentTextLabel.text = commentData[indexPath.row].commentText
        cell.likeNumLabel.text = "\(commentData[indexPath.row].commentLikedNumber)"
        cell.commentNumLabel.text = "\(commentData[indexPath.row].commentLikedNumber)"
        cell.profileImageView.load(url: "\(commentData[indexPath.row].memberProfileUrl)")
        
        cell.likeStackView.snp.remakeConstraints {
            $0.top.equalTo(cell.contentTextLabel.snp.bottom).offset(4.adjusted)
            $0.height.equalTo(cell.commentStackView)
            $0.trailing.equalTo(cell.kebabButton).inset(8.adjusted)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        cell.commentStackView.isHidden = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let contentId = commentData[indexPath.row].contentId
        NotificationCenter.default.post(name: MyPageContentViewController.pushViewController, object: nil, userInfo: ["contentId": contentId])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 343.adjusted, height: 210.adjusted)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 24.adjusted)
    }
}

extension MyPageCommentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if yOffset > 0 {
            scrollView.isScrollEnabled = true
        } else if yOffset < 0 {
            scrollView.isScrollEnabled = false
        }
    }
}

extension MyPageCommentViewController: DontBePopupDelegate {
    func cancleButtonTapped() {
//        transparentButtonPopupView.alpha = 0
    }
    
    func confirmButtonTapped() {
//        transparentButtonPopupView.alpha = 0
        // ✅ 투명도 주기 버튼 클릭 시 액션 추가
    }
}
