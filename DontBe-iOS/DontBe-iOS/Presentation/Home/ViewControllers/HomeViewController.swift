//
//  HomeViewController.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/8/24.
//

import Combine
import SafariServices
import UIKit

import SnapKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var tabBarHeight: CGFloat = 0
    var showUploadToastView: Bool = false
    var deleteBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnDelete)
    var warnBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnWarn)
    let refreshControl = UIRefreshControl()
    var transparentPopupVC = TransparentPopupViewController()
    var deletePostPopupVC = DeletePopupViewController(viewModel: DeletePostViewModel(networkProvider: NetworkService()))
    
    private var cancelBag = CancelBag()
    private let viewModel: HomeViewModel
    let postViewModel = PostViewModel(networkProvider: NetworkService())
    
    var contentId: Int = 0
    var alarmTriggerType: String = ""
    var targetMemberId: Int = 0
    var alarmTriggerdId: Int = 0
    
    let warnUserURL = NSURL(string: "\(StringLiterals.Network.warnUserGoogleFormURL)")
    // MARK: - UI Components
    
    private let myView = HomeView()
    lazy var homeCollectionView = HomeCollectionView().collectionView
    private var uploadToastView: DontBeToastView?
    private var alreadyTransparencyToastView: DontBeToastView?
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = myView
    }
    
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
        setNotification()
        setAddTarget()
        bindViewModel()
        setRefreshControll()
    }
    
    // MARK: - TabBar Height
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeAreaHeight = view.safeAreaInsets.bottom
        let tabBarHeight: CGFloat = 70.0
        
        self.tabBarHeight = tabBarHeight + safeAreaHeight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

        refreshPost()
    }
}

// MARK: - Extensions

extension HomeViewController {
    private func setUI() {
        self.view.backgroundColor = UIColor.donGray1
        transparentPopupVC.modalPresentationStyle = .overFullScreen
        deletePostPopupVC.modalPresentationStyle = .overFullScreen
    }
    
    private func setHierarchy() {
        view.addSubviews(homeCollectionView)
    }
    
    private func setLayout() {
        homeCollectionView.snp.makeConstraints {
            $0.top.equalTo(myView.safeAreaLayoutGuide.snp.top).offset(52.adjusted)
            $0.bottom.equalTo(tabBarHeight.adjusted)
            $0.width.equalToSuperview()
        }
    }
    
    private func setAddTarget() {
        deleteBottomsheet.deleteButton.addTarget(self, action: #selector(deletePost), for: .touchUpInside)
    }
    
    @objc
    func deletePost() {
        popView()
        presentView()
    }
    
    @objc
    func warnUser() {
        let safariView: SFSafariViewController = SFSafariViewController(url: self.warnUserURL! as URL)
        self.present(safariView, animated: true, completion: nil)
    }
    
    func popView() {
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
    }
    
     func presentView() {
        deletePostPopupVC.contentId = self.contentId
        self.present(self.deletePostPopupVC, animated: false, completion: nil)
    }
    
    @objc
    private func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setDelegate() {
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        transparentPopupVC.transparentButtonPopupView.delegate = self
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showToast(_:)), name: WriteViewController.showWriteToastNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(popViewController), name: DeletePopupViewController.popViewController, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissPopupNotification(_:)), name: NSNotification.Name("DismissDetailView"), object: nil)
    }
    
    @objc func didDismissPopupNotification(_ notification: Notification) {
          DispatchQueue.main.async {
              self.refreshPost()
          }
      }
    
    private func setRefreshControll() {
        refreshControl.addTarget(self, action: #selector(refreshPost), for: .valueChanged)
        homeCollectionView.refreshControl = refreshControl
        refreshControl.backgroundColor = .donGray1
    }
    
    @objc
    func refreshPost() {
        DispatchQueue.main.async {
            self.bindViewModel()
        }
        self.homeCollectionView.reloadData()
        self.perform(#selector(self.finishedRefreshing), with: nil, afterDelay: 0.1)
    }
    
    @objc
    func finishedRefreshing() {
        refreshControl.endRefreshing()
    }
    
    @objc func showToast(_ notification: Notification) {
        if let showToast = notification.userInfo?["showToast"] as? Bool {
            if showToast == true {
                DispatchQueue.main.async {
                    self.uploadToastView = DontBeToastView()
                    
                    self.view.addSubviews(self.uploadToastView ?? DontBeToastView())
                    
                    self.uploadToastView?.snp.makeConstraints {
                        $0.leading.trailing.equalToSuperview().inset(16.adjusted)
                        $0.bottom.equalTo(self.tabBarHeight.adjusted).inset(6.adjusted)
                        $0.height.equalTo(44)
                    }
                    
                    var value: Double = 0.0
                    let duration: TimeInterval = 1.0 // 애니메이션 기간 (초 단위)
                    let increment: Double = 0.01 // 증가량
                    
                    // 0에서 1까지 1초 동안 0.01씩 증가하는 애니메이션 블록
                    UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
                        for i in 1...100 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + (duration / 100) * TimeInterval(i)) {
                                value = Double(i) * increment
                                self.uploadToastView?.circleProgressBar.value = value
                            }
                        }
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.uploadToastView?.circleProgressBar.alpha = 0
                        self.uploadToastView?.checkImageView.alpha = 1
                        self.uploadToastView?.toastLabel.text = StringLiterals.Toast.uploaded
                        self.uploadToastView?.container.backgroundColor = .donPrimary
                    }
                    
                    UIView.animate(withDuration: 1.0, delay: 3, options: .curveEaseIn) {
                        self.uploadToastView?.alpha = 0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        self.uploadToastView?.circleProgressBar.alpha = 1
                        self.uploadToastView?.checkImageView.alpha = 0
                        self.uploadToastView?.toastLabel.text = StringLiterals.Toast.uploading
                        self.uploadToastView?.container.backgroundColor = .donGray3
                    }
                }
            }
        }
    }
    
    func showAlreadyTransparencyToast() {
        DispatchQueue.main.async {
            self.alreadyTransparencyToastView = DontBeToastView()
            self.alreadyTransparencyToastView?.toastLabel.text = StringLiterals.Toast.alreadyTransparency
            self.alreadyTransparencyToastView?.circleProgressBar.alpha = 0
            self.alreadyTransparencyToastView?.checkImageView.alpha = 1
            self.alreadyTransparencyToastView?.checkImageView.image = ImageLiterals.Home.icnNotice
            self.alreadyTransparencyToastView?.container.backgroundColor = .donPrimary
            
            self.view.addSubviews(self.alreadyTransparencyToastView ?? DontBeToastView())
            
            self.alreadyTransparencyToastView?.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(16.adjusted)
                $0.bottom.equalTo(self.tabBarHeight.adjusted).inset(6.adjusted)
                $0.height.equalTo(44.adjusted)
            }
            
            UIView.animate(withDuration: 1.5, delay: 1, options: .curveEaseIn) {
                self.alreadyTransparencyToastView?.alpha = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.alreadyTransparencyToastView?.removeFromSuperview()
            }
        }
    }
}

// MARK: - Network

extension HomeViewController {
    private func bindViewModel() {
        let input = HomeViewModel.Input(viewUpdate: Just(()).eraseToAnyPublisher(), likeButtonTapped: nil)
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.getData
            .receive(on: RunLoop.main)
            .sink { _ in
                self.homeCollectionView.reloadData()
            }
            .store(in: self.cancelBag)
    }
    
    private func postLikeButtonAPI(isClicked: Bool, contentId: Int) {
        // 최초 한 번만 publisher 생성
        var likeButtonTapped: AnyPublisher<(Bool, Int), Never>?  = Just(())
                .map { _ in return (!isClicked, contentId) }
                .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: false)
                .eraseToAnyPublisher()

        let input = HomeViewModel.Input(viewUpdate: nil, likeButtonTapped: likeButtonTapped)

        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)

        output.toggleLikeButton
            .sink { value in
                print(value)
            }
            .store(in: self.cancelBag)
    }
}

extension HomeViewController: UICollectionViewDelegate { }

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sortedData = viewModel.postData.sorted {
            $0.time.compare($1.time, options: .numeric) == .orderedDescending
        }
        
        // Replace the viewModel.postData array with the sortedData
        viewModel.postData = sortedData
        
        return viewModel.postData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        HomeCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
        cell.alarmTriggerType = "contentGhost"
        cell.targetMemberId = viewModel.postData[indexPath.row].memberId
        cell.alarmTriggerdId = viewModel.postData[indexPath.row].contentId
        if viewModel.postData[indexPath.row].memberId == loadUserData()?.memberId {
            cell.ghostButton.isHidden = true
            cell.verticalTextBarView.isHidden = true
            self.deleteBottomsheet.warnButton.removeFromSuperview()
            
            cell.KebabButtonAction = {
                self.deleteBottomsheet.showSettings()
                self.deleteBottomsheet.deleteButton.addTarget(self, action: #selector(self.deletePost), for: .touchUpInside)
                self.contentId = self.viewModel.postData[indexPath.row].contentId
            }
        } else {
            cell.ghostButton.isHidden = false
            cell.verticalTextBarView.isHidden = false
            self.warnBottomsheet.deleteButton.removeFromSuperview()
            
            cell.KebabButtonAction = {
                self.warnBottomsheet.showSettings()
                self.warnBottomsheet.warnButton.addTarget(self, action: #selector(self.warnUser), for: .touchUpInside)
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
            self.postLikeButtonAPI(isClicked: cell.isLiked, contentId: self.viewModel.postData[indexPath.row].contentId)
        }

        cell.TransparentButtonAction = {
            self.alarmTriggerType = cell.alarmTriggerType
            self.targetMemberId = cell.targetMemberId
            self.alarmTriggerdId = cell.alarmTriggerdId
            self.present(self.transparentPopupVC, animated: false, completion: nil)
        }
        cell.nicknameLabel.text = viewModel.postData[indexPath.row].memberNickname
        cell.transparentLabel.text = "투명도 \(viewModel.postData[indexPath.row].memberGhost)%"
        cell.contentTextLabel.text = viewModel.postData[indexPath.row].contentText
        cell.likeNumLabel.text = "\(viewModel.postData[indexPath.row].likedNumber)"
        cell.commentNumLabel.text = "\(viewModel.postData[indexPath.row].commentNumber)"
        cell.timeLabel.text = "\(viewModel.postData[indexPath.row].time.formattedTime())"
        cell.profileImageView.load(url: "\(viewModel.postData[indexPath.row].memberProfileUrl)")
        cell.likeButton.setImage(viewModel.postData[indexPath.row].isLiked ? ImageLiterals.Posting.btnFavoriteActive : ImageLiterals.Posting.btnFavoriteInActive, for: .normal)
        cell.isLiked = self.viewModel.postData[indexPath.row].isLiked
        
        // 내가 투명도를 누른 유저인 경우 -85% 적용
        if self.viewModel.postData[indexPath.row].isGhost {
            cell.grayView.alpha = 0.85
        } else {
            let alpha = self.viewModel.postData[indexPath.row].memberGhost
            cell.grayView.alpha = CGFloat(Double(-alpha) / 100)
        }
        
        self.contentId = viewModel.postData[indexPath.row].contentId
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationViewController = PostViewController(viewModel: PostViewModel(networkProvider: NetworkService()))
        destinationViewController.contentId = viewModel.postData[indexPath.row].contentId
        self.navigationController?.pushViewController(destinationViewController, animated: true)
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
        self.dismiss(animated: false)
    }
    
    func confirmButtonTapped() {
        self.dismiss(animated: false)
        Task {
            do {
                if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                    let result = try await self.viewModel.postDownTransparency(accessToken: accessToken,
                                                                               alarmTriggerType: self.alarmTriggerType,
                                                                               targetMemberId: self.targetMemberId,
                                                                               alarmTriggerId: self.alarmTriggerdId)
                    refreshPost()
                    if result?.status == 400 {
                        // 이미 투명도를 누른 대상인 경우, 토스트 메시지 보여주기
                        showAlreadyTransparencyToast()
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
