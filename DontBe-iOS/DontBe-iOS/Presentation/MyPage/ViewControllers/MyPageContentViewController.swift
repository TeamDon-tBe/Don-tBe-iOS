//
//  MyPageContentViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/11/24.
//

import Combine
import SafariServices
import UIKit

import SnapKit

final class MyPageContentViewController: UIViewController {
    
    // MARK: - Properties
    
    static let pushViewController = NSNotification.Name("pushViewController")
    static let reloadData = NSNotification.Name("reloadData")
    static let warnUserButtonTapped = NSNotification.Name("warnUserButtonTapped")
    static let ghostButtonTapped = NSNotification.Name("ghostButtonContentTapped")
    
    var showUploadToastView: Bool = false
    var deleteBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnDelete)
    private let refreshControl = UIRefreshControl()
    
    private let viewModel: HomeViewModel
    private var cancelBag = CancelBag()
    
    var profileData: [MypageProfileResponseDTO] = []
    var contentData: [MyPageMemberContentResponseDTO] = []
    
    var contentId: Int = 0
    var alarmTriggerType: String = ""
    var targetMemberId: Int = 0
    var alarmTriggerdId: Int = 0
    
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
        button.isHidden = true
        return button
    }()
    
    var deletePostPopupVC = DeletePopupViewController(viewModel: DeletePostViewModel(networkProvider: NetworkService()))
    var warnBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnWarn)
    
    // MARK: - Life Cycles
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setRefreshControll()
        setNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: MyPageContentViewController.reloadData, object: nil)
    }
}

// MARK: - Extensions

extension MyPageContentViewController {
    private func setUI() {
        self.view.backgroundColor = UIColor.donGray1
        self.navigationController?.navigationBar.isHidden = true
        
        deletePostPopupVC.modalPresentationStyle = .overFullScreen
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
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: MyPageContentViewController.reloadData, object: nil)
    }
    
    private func setRefreshControll() {
        refreshControl.addTarget(self, action: #selector(refreshPost), for: .valueChanged)
        homeCollectionView.refreshControl = refreshControl
        refreshControl.backgroundColor = .donGray1
    }
    
    @objc
    func reloadData(_ notification: Notification) {
        refreshPost()
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
    
    @objc
    private func deleteButtonTapped() {
        popDeleteView()
        presentView()
    }
    
    @objc
    private func warnButtonTapped() {
        popWarnView()
        NotificationCenter.default.post(name: MyPageContentViewController.warnUserButtonTapped, object: nil)
    }
    
    func popDeleteView() {
        if UIApplication.shared.keyWindowInConnectedScenes != nil {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.deleteBottomsheet.dimView.alpha = 0
                if let window = UIApplication.shared.keyWindowInConnectedScenes {
                    self.deleteBottomsheet.bottomsheetView.frame = CGRect(x: 0, y: window.frame.height, width: self.deleteBottomsheet.frame.width, height: self.deleteBottomsheet.bottomsheetView.frame.height)
                }
            })
            deleteBottomsheet.dimView.removeFromSuperview()
            deleteBottomsheet.bottomsheetView.removeFromSuperview()
        }
        refreshPost()
    }
    
    func popWarnView() {
        if UIApplication.shared.keyWindowInConnectedScenes != nil {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.warnBottomsheet.dimView.alpha = 0
                if let window = UIApplication.shared.keyWindowInConnectedScenes {
                    self.warnBottomsheet.bottomsheetView.frame = CGRect(x: 0, y: window.frame.height, width: self.deleteBottomsheet.frame.width, height: self.warnBottomsheet.bottomsheetView.frame.height)
                }
            })
            warnBottomsheet.dimView.removeFromSuperview()
            warnBottomsheet.bottomsheetView.removeFromSuperview()
        }
        refreshPost()
    }
    
    func presentView() {
        deletePostPopupVC.contentId = self.contentId
        self.present(self.deletePostPopupVC, animated: false, completion: nil)
    }
    
    private func postLikeButtonAPI(isClicked: Bool, contentId: Int) {
        // 최초 한 번만 publisher 생성
        let likeButtonTapped: AnyPublisher<(Bool, Int), Never>?  = Just(())
                .map { _ in return (!isClicked, contentId) }
                .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: false)
                .eraseToAnyPublisher()

        let input = HomeViewModel.Input(viewUpdate: nil, likeButtonTapped: likeButtonTapped)

        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)

        output.toggleLikeButton
            .sink { _ in }
            .store(in: self.cancelBag)
    }
}

extension MyPageContentViewController: UICollectionViewDelegate { }

extension MyPageContentViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        HomeCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
        
        cell.alarmTriggerType = "contentGhost"
        cell.targetMemberId = contentData[indexPath.row].memberId
        cell.alarmTriggerdId = contentData[indexPath.row].contentId
        
        if contentData[indexPath.row].memberId == loadUserData()?.memberId {
            cell.ghostButton.isHidden = true
            cell.verticalTextBarView.isHidden = true
            self.deleteBottomsheet.warnButton.removeFromSuperview()
            
            cell.KebabButtonAction = {
                self.deleteBottomsheet.showSettings()
                self.deleteBottomsheet.deleteButton.addTarget(self, action: #selector(self.deleteButtonTapped), for: .touchUpInside)
                self.contentId = self.contentData[indexPath.row].contentId
            }
        } else {
            cell.ghostButton.isHidden = false
            cell.verticalTextBarView.isHidden = false
            self.warnBottomsheet.deleteButton.removeFromSuperview()
            
            cell.KebabButtonAction = {
                self.warnBottomsheet.showSettings()
                self.warnBottomsheet.warnButton.addTarget(self, action: #selector(self.warnButtonTapped), for: .touchUpInside)
                self.contentId = self.contentData[indexPath.row].contentId
            }
        }
        
        cell.LikeButtonAction = {
            if cell.isLiked == true {
                cell.likeNumLabel.text = String((Int(cell.likeNumLabel.text ?? "") ?? 0) - 1)
            } else {
                cell.likeNumLabel.text = String((Int(cell.likeNumLabel.text ?? "") ?? 0) + 1)
            }
            cell.isLiked.toggle()
            cell.likeButton.setImage(cell.isLiked ? ImageLiterals.Posting.btnFavoriteActive : ImageLiterals.Posting.btnFavoriteInActive, for: .normal)
            self.postLikeButtonAPI(isClicked: cell.isLiked, contentId: self.contentData[indexPath.row].contentId)
        }
        
        cell.ProfileButtonAction = {
            let memberId = self.contentData[indexPath.row].memberId

            if memberId == loadUserData()?.memberId ?? 0  {
                self.tabBarController?.selectedIndex = 3
                if let selectedViewController = self.tabBarController?.selectedViewController {
                    self.applyTabBarAttributes(to: selectedViewController.tabBarItem, isSelected: true)
                }
                let myViewController = self.tabBarController?.viewControllers ?? [UIViewController()]
                for (index, controller) in myViewController.enumerated() {
                    if let tabBarItem = controller.tabBarItem {
                        if index != self.tabBarController?.selectedIndex {
                            self.applyTabBarAttributes(to: tabBarItem, isSelected: false)
                        }
                    }
                }
            } else {
                let viewController = MyPageViewController(viewModel: MyPageViewModel(networkProvider: NetworkService()))
                viewController.memberId = memberId
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
        cell.TransparentButtonAction = {
            self.alarmTriggerType = cell.alarmTriggerType
            self.targetMemberId = cell.targetMemberId
            self.alarmTriggerdId = cell.alarmTriggerdId
            NotificationCenter.default.post(name: MyPageContentViewController.ghostButtonTapped, object: nil)
        }
        
        cell.nicknameLabel.text = contentData[indexPath.row].memberNickname
        cell.transparentLabel.text = "투명도 \(contentData[indexPath.row].memberGhost)%"
        cell.timeLabel.text = "\(contentData[indexPath.row].time.formattedTime())"
        cell.contentTextLabel.text = contentData[indexPath.row].contentText
        cell.likeNumLabel.text = "\(contentData[indexPath.row].likedNumber)"
        cell.commentNumLabel.text = "\(contentData[indexPath.row].commentNumber)"
        cell.profileImageView.load(url: "\(contentData[indexPath.row].memberProfileUrl)")
        cell.likeButton.setImage(contentData[indexPath.row].isLiked ? ImageLiterals.Posting.btnFavoriteActive : ImageLiterals.Posting.btnFavoriteInActive, for: .normal)
        cell.isLiked = contentData[indexPath.row].isLiked
        
        // 내가 투명도를 누른 유저인 경우 -85% 적용
        if contentData[indexPath.row].isGhost {
            cell.grayView.alpha = 0.85
        } else {
            let alpha = contentData[indexPath.row].memberGhost
            cell.grayView.alpha = CGFloat(Double(-alpha) / 100)
        }
        
        self.contentId = contentData[indexPath.row].contentId
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let contentId = contentData[indexPath.row].contentId
        NotificationCenter.default.post(name: MyPageContentViewController.pushViewController, object: nil, userInfo: ["contentId": contentId])
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = homeCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeCollectionFooterView", for: indexPath) as? HomeCollectionFooterView else { return UICollectionReusableView() }
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 343.adjusted, height: 210.adjusted)
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
//        transparentButtonPopupView.alpha = 0
    }
    
    func confirmButtonTapped() {
//        transparentButtonPopupView.alpha = 0
        // ✅ 투명도 주기 버튼 클릭 시 액션 추가
    }
}
