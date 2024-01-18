//
//  PostViewController.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/12/24.
//

import Combine
import SafariServices
import UIKit

import SnapKit

final class PostViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var postUserNickname = postView.postNicknameLabel.text
    private lazy var postDividerView = postView.horizontalDivierView
    private lazy var ghostButton = postView.ghostButton
    let refreshControl = UIRefreshControl()
    var deleteBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnDelete)
    var warnBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnWarn)
    var transparentPopupVC = TransparentPopupViewController()
    var deletePostPopupVC = DeletePopupViewController(viewModel: DeletePostViewModel(networkProvider: NetworkService()))
    var deleteReplyPopupVC = DeleteReplyViewController(viewModel: DeleteReplyViewModel(networkProvider: NetworkService()))
    var writeReplyVC = WriteReplyViewController(viewModel: WriteReplyViewModel(networkProvider: NetworkService()))
    var writeReplyView = WriteReplyView()
    
    var collectionHeaderView: PostCollectionViewHeader?
    
    let warnUserURL = NSURL(string: "\(StringLiterals.Network.warnUserGoogleFormURL)")

    let viewModel: PostViewModel
    private var cancelBag = CancelBag()
    
    var contentId: Int = 0
    var commentId: Int = 0
    var memberId: Int = 0
    var alarmTriggerType: String = ""
    var targetMemberId: Int = 0
    var alarmTriggerdId: Int = 0
    var postViewHeight = 0
    var userNickName: String = ""
    var contentText: String = ""
    
    // MARK: - UI Components
    
    lazy var postView = PostView()
    
    let grayView: DontBeTransparencyGrayView = {
        let view = DontBeTransparencyGrayView()
        view.alpha = 0
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var textFieldView = PostReplyTextFieldView()
    var postReplyCollectionView = PostReplyCollectionView().collectionView
    private lazy var greenTextField = textFieldView.greenTextFieldView
    private var uploadToastView: DontBeToastView?
    private var alreadyTransparencyToastView: DontBeToastView?
    
    private let verticalBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray3
        return view
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setAddTarget()
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        setTextFieldGesture()
        setNotification()
        setRefreshControll()
        setRegister()
    }
    
    init(viewModel: PostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    private func setRegister() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshPost()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didDismissDetailNotification(_:)),
            name: NSNotification.Name("DismissReplyView"),
            object: nil
        )
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = StringLiterals.Post.navigationTitleLabel
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        self.tabBarController?.tabBar.isHidden = false
        
        let backButton = UIBarButtonItem.backButton(target: self, action: #selector(backButtonPressed))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.textFieldView.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(56.adjusted)
        }
        getAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = .clear
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("likeButtonTapped"), object: nil)
    }
}

// MARK: - Extensions

extension PostViewController {
    private func setUI() {
        self.view.backgroundColor = .donWhite
        textFieldView.isUserInteractionEnabled = true
        transparentPopupVC.modalPresentationStyle = .overFullScreen
        deletePostPopupVC.modalPresentationStyle = .overFullScreen
        deleteReplyPopupVC.modalPresentationStyle = .overFullScreen
    }
    
    private func setHierarchy() {
        view.addSubviews(grayView,
                         verticalBarView,
                         postReplyCollectionView,
                         textFieldView)
    }
    
    private func setLayout() {
        
        grayView.snp.makeConstraints {
            $0.top.equalTo(500)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        postReplyCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(textFieldView.snp.bottom).offset(-56.adjusted)
            $0.leading.trailing.equalToSuperview()
        }
        
        verticalBarView.snp.makeConstraints {
            $0.top.equalTo(postReplyCollectionView)
            $0.leading.equalToSuperview().inset(16.adjusted)
            $0.width.equalTo(1.adjusted)
            $0.bottom.equalTo(postReplyCollectionView.snp.bottom)
        }
        
        textFieldView.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(70.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56.adjusted)
        }
    }
    
    private func setDelegate() {
        postReplyCollectionView.dataSource = self
        postReplyCollectionView.delegate = self
        transparentPopupVC.transparentButtonPopupView.delegate = self
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showToast(_:)), name: WriteReplyViewController.showUploadToastNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissViewController), name: CancelReplyPopupViewController.popViewController, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector( self.likeButtonAction), name: NSNotification.Name("likeButtonTapped"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector( self.profileButtonAction), name: NSNotification.Name("profileButtonTapped"), object: nil)
    }
    
    @objc func didDismissDetailNotification(_ notification: Notification) {
        DispatchQueue.main.async {
            self.getAPI()
            self.postReplyCollectionView.reloadData()
        }
    }
    private func setRefreshControll() {
        refreshControl.addTarget(self, action: #selector(refreshPost), for: .valueChanged)
        postReplyCollectionView.refreshControl = refreshControl
        refreshControl.backgroundColor = .donWhite
    }
    
    @objc func showToast(_ notification: Notification) {
        if let showToast = notification.userInfo?["showToast"] as? Bool {
            if showToast == true {
                
                uploadToastView = DontBeToastView()
                
                view.addSubviews(uploadToastView ?? DontBeToastView())
                
                uploadToastView?.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview().inset(16.adjusted)
                    $0.bottom.equalTo(70).inset(6.adjusted)
                    $0.height.equalTo(48.adjusted)
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
                $0.bottom.equalTo(70).inset(6.adjusted)
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
    
    @objc
    private func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setAddTarget() {
        self.collectionHeaderView?.ghostButton.addTarget(self, action: #selector(transparentShowPopupButton), for: .touchUpInside)
        self.postView.kebabButton.addTarget(self, action: #selector(self.deleteOrWarn), for: .touchUpInside)
    }
    
    @objc
    func deleteOrWarn() {
        if self.memberId == loadUserData()?.memberId ?? 0 {
            self.deleteBottomsheet.showSettings()
            addDeleteButtonAction()
        } else {
            self.warnBottomsheet.showSettings()
            addWarnUserButtonAction()
        }
    }
    
    @objc
    func likeButtonAction() {
        let likeButtonTapped: AnyPublisher<(Bool, Int), Never>? = Just(())
            .map { _ in return (self.postView.isLiked, self.contentId) }
            .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: false)
            .eraseToAnyPublisher()
        
        let input = PostViewModel.Input(viewUpdate: nil, likeButtonTapped: likeButtonTapped, collectionViewUpdata: nil, commentLikeButtonTapped: nil)
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.toggleLikeButton
            .sink { _ in }
            .store(in: self.cancelBag)
        
        self.postView.isLiked.toggle()
    }
    
    @objc
    func profileButtonAction() {
        self.pushToMypage()
    }
    
    private func addDeleteButtonAction() {
        self.deleteBottomsheet.warnButton.removeFromSuperview()
        self.deleteBottomsheet.deleteButton.addTarget(self, action: #selector(deletePost), for: .touchUpInside)
    }
    
    private func addWarnUserButtonAction() {
        self.warnBottomsheet.deleteButton.removeFromSuperview()
        self.warnBottomsheet.warnButton.addTarget(self, action: #selector(warnUser), for: .touchUpInside)
    }
    
    @objc
    func deletePost() {
        popView()
        deleteReplyPopupView()
    }
    
    @objc
    func deleteReplyPost() {
        print("답글 삭제")
        popView()
        deleteReplyPopupView()
    }
    
    @objc
    private func pushToMypage() {
        if self.memberId == loadUserData()?.memberId ?? 0  {
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
    
    func popView() {
        if UIApplication.shared.keyWindowInConnectedScenes != nil {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.deleteBottomsheet.dimView.alpha = 0
                self.postView.deleteBottomsheet.dimView.alpha = 0
                if let window = UIApplication.shared.keyWindowInConnectedScenes {
                    self.deleteBottomsheet.bottomsheetView.frame = CGRect(x: 0, y: window.frame.height, width: self.deleteBottomsheet.frame.width, height: self.deleteBottomsheet.bottomsheetView.frame.height)
                    self.postView.deleteBottomsheet.bottomsheetView.frame = CGRect(x: 0, y: window.frame.height, width: self.postView.deleteBottomsheet.frame.width, height: self.postView.deleteBottomsheet.bottomsheetView.frame.height)
                }
            })
            deleteBottomsheet.dimView.removeFromSuperview()
            deleteBottomsheet.bottomsheetView.removeFromSuperview()
            postView.deleteBottomsheet.dimView.removeFromSuperview()
            postView.deleteBottomsheet.bottomsheetView.removeFromSuperview()
        }
    }
    
    func presentView() {
        deletePostPopupVC.contentId = self.contentId
        
        self.present(self.deletePostPopupVC, animated: false, completion: nil)
    }
    
    func deleteReplyPopupView() {
        deleteReplyPopupVC.commentId = self.commentId
        self.present(self.deleteReplyPopupVC, animated: false, completion: nil)
    }
    
    @objc
    func transparentShowPopupButton() {
        self.alarmTriggerType = "contentGhost"
        self.targetMemberId = self.memberId
        self.alarmTriggerdId = self.contentId
        self.present(self.transparentPopupVC, animated: false, completion: nil)
    }
    
    private func setTextFieldGesture() {
        greenTextField.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(textFieldDidTapped))
        gesture.cancelsTouchesInView = false
        greenTextField.addGestureRecognizer(gesture)
    }
    
    @objc func textFieldDidTapped() {
        showReplyVC()
    }
    
    private func showReplyVC() {
        let viewController = WriteReplyViewController(viewModel: WriteReplyViewModel(networkProvider: NetworkService()))
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.contentId = self.contentId
        viewController.userNickname = self.userNickName
        viewController.userContent = self.contentText
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc
    func refreshPost() {
        DispatchQueue.main.async {
            self.getAPI()
        }
        self.postReplyCollectionView.reloadData()
        self.perform(#selector(self.finishedRefreshing), with: nil, afterDelay: 0.1)
    }
    
    @objc
    func finishedRefreshing() {
        refreshControl.endRefreshing()
    }
    
    @objc
    private func dismissViewController() {
        self.dismiss(animated: false)
    }
    
    @objc private func warnUser() {
        let safariView: SFSafariViewController = SFSafariViewController(url: self.warnUserURL! as URL)
        self.present(safariView, animated: true, completion: nil)
    }
}

// MARK: - Network

extension PostViewController {
    private func getAPI() {
        let input = PostViewModel.Input(viewUpdate: Just((contentId)).eraseToAnyPublisher(), likeButtonTapped: nil, collectionViewUpdata: Just((contentId)).eraseToAnyPublisher(), commentLikeButtonTapped: nil)
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.getPostData
            .receive(on: RunLoop.main)
            .sink { data in
                self.memberId = data.memberId
                self.bindPostData(data: data)
            }
            .store(in: self.cancelBag)
        
        output.getPostReplyData
            .receive(on: RunLoop.main)
            .sink { data in
                self.postReplyCollectionView.reloadData()
            }
            .store(in: self.cancelBag)
    }
    
    private func bindPostData(data: PostDetailResponseDTO) {
        self.postView.isGhost = data.isGhost
        self.postView.memberGhost = data.memberGhost
        
        self.collectionHeaderView?.profileImageView.load(url: data.memberProfileUrl)
        self.textFieldView.replyTextFieldLabel.text = "\(data.memberNickname)" + StringLiterals.Post.textFieldLabel
        self.postView
            .postNicknameLabel.text = data.memberNickname
        self.postUserNickname = "\(data.memberNickname)"
        self.userNickName = "\(data.memberNickname)"
        self.postView.contentTextLabel.text = data.contentText
        self.postView.transparentLabel.text = "투명도 \(data.memberGhost)%"
        self.postView.timeLabel.text = data.time.formattedTime()
        self.postView.likeNumLabel.text = "\(data.likedNumber)"
        self.postView.commentNumLabel.text = "\(data.commentNumber)"
        self.postView.profileImageView.load(url: "\(data.memberProfileUrl)")
        postView.likeButton.setImage(data.isLiked ? ImageLiterals.Posting.btnFavoriteActive : ImageLiterals.Posting.btnFavoriteInActive, for: .normal)
        self.memberId = data.memberId
        self.postView.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushToMypage)))
        self.postView.isLiked = data.isLiked
        
        self.userNickName = "\(data.memberNickname)"
        self.contentText = "\(data.contentText)"
        
        // 내가 투명도를 누른 유저인 경우 -85% 적용
        if data.isGhost {
            self.grayView.alpha = 0.85
        } else {
            let alpha = data.memberGhost
            self.grayView.alpha = CGFloat(Double(-alpha) / 100)
        }
        
        if self.memberId == loadUserData()?.memberId {
            self.postView.ghostButton.isHidden = true
            self.postView.verticalTextBarView.isHidden = true
        } else {
            self.postView.ghostButton.isHidden = false
            self.postView.verticalTextBarView.isHidden = false
        }
    }
    
    private func postCommentLikeButtonAPI(isClicked: Bool, commentId: Int, commentText: String) {
        // 최초 한 번만 publisher 생성
        let commentLikedButtonTapped: AnyPublisher<(Bool, Int, String), Never>? = Just(())
            .map { _ in return (!isClicked, commentId, commentText) }
            .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: false)
            .eraseToAnyPublisher()
        
        let input = PostViewModel.Input(viewUpdate: nil, likeButtonTapped: nil, collectionViewUpdata: nil, commentLikeButtonTapped: commentLikedButtonTapped)
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.toggleLikeButton
            .sink { _ in }
            .store(in: self.cancelBag)
    }
}

extension PostViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sortedData = viewModel.postReplyData.sorted {
            $0.time.compare($1.time, options: .numeric) == .orderedDescending
        }
        
        viewModel.postReplyData = sortedData
        return viewModel.postReplyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        PostReplyCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)

        cell.alarmTriggerType = "commentGhost"
        cell.targetMemberId = viewModel.postReplyData[indexPath.row].memberId
        cell.alarmTriggerdId = self.contentId
        cell.nicknameLabel.text = viewModel.postReplyData[indexPath.row].memberNickname
        
        if viewModel.postReplyData[indexPath.row].memberId == loadUserData()?.memberId {
            cell.ghostButton.isHidden = true
            cell.verticalTextBarView.isHidden = true
            self.deleteBottomsheet.warnButton.removeFromSuperview()
            
            cell.KebabButtonAction = {
                print("나야")
                self.deleteBottomsheet.showSettings()
                self.deleteBottomsheet.deleteButton.addTarget(self, action: #selector(self.deletePost), for: .touchUpInside)
                self.commentId = self.viewModel.postReplyData[indexPath.row].commentId
            }
        } else {
            cell.ghostButton.isHidden = false
            cell.verticalTextBarView.isHidden = false
            self.warnBottomsheet.deleteButton.removeFromSuperview()
            
            cell.KebabButtonAction = {
                print("너야")
                self.warnBottomsheet.showSettings()
                self.warnBottomsheet.warnButton.addTarget(self, action: #selector(self.warnUser), for: .touchUpInside)
                self.commentId = self.viewModel.postReplyData[indexPath.row].commentId
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
            
            self.postCommentLikeButtonAPI(isClicked: cell.isLiked, commentId: self.viewModel.postReplyData[indexPath.row].commentId, commentText: self.viewModel.postReplyData[indexPath.row].commentText)
        }
        cell.TransparentButtonAction = {
            self.alarmTriggerType = cell.alarmTriggerType
            self.targetMemberId = cell.targetMemberId
            self.alarmTriggerdId = cell.alarmTriggerdId
            self.present(self.transparentPopupVC, animated: false, completion: nil)
        }
        cell.ProfileButtonAction = {
            self.memberId = self.viewModel.postReplyData[indexPath.row].memberId
            self.pushToMypage()
        }
        cell.nicknameLabel.text = viewModel.postReplyData[indexPath.row].memberNickname
        cell.transparentLabel.text = "투명도 \(viewModel.postReplyData[indexPath.row].memberGhost)%"
        cell.contentTextLabel.text = viewModel.postReplyData[indexPath.row].commentText
        cell.likeNumLabel.text = "\(viewModel.postReplyData[indexPath.row].commentLikedNumber)"
        cell.timeLabel.text = "\(viewModel.postReplyData[indexPath.row].time.formattedTime())"
        cell.profileImageView.load(url: "\(viewModel.postReplyData[indexPath.row].memberProfileUrl)")
        self.commentId = viewModel.postReplyData[indexPath.row].commentId
        cell.likeButton.setImage(viewModel.postReplyData[indexPath.row].isLiked ? ImageLiterals.Posting.btnFavoriteActive : ImageLiterals.Posting.btnFavoriteInActive, for: .normal)
        cell.isLiked = self.viewModel.postReplyData[indexPath.row].isLiked
        // 내가 투명도를 누른 유저인 경우 -85% 적용
        if self.viewModel.postReplyData[indexPath.row].isGhost {
            cell.grayView.alpha = 0.85
        } else {
            let alpha = self.viewModel.postReplyData[indexPath.row].memberGhost
            cell.grayView.alpha = CGFloat(Double(-alpha) / 100)
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PostCollectionViewHeader", for: indexPath) as? PostCollectionViewHeader
            else { return UICollectionReusableView()
            }
            
            header.transparentLabel.text = self.postView.transparentLabel.text
            header.postNicknameLabel.text = self.postView.postNicknameLabel.text
            header.timeLabel.text = self.postView.timeLabel.text
            header.contentTextLabel.text = self.postView.contentTextLabel.text
            header.likeNumLabel.text = self.postView.likeNumLabel.text
            header.commentNumLabel.text = self.postView.commentNumLabel.text
            header.isLiked = self.postView.isLiked
            print(header.isLiked)
            print("DSFAFSDFA")
            header.likeButton.setImage(header.isLiked ? ImageLiterals.Posting.btnFavoriteActive : ImageLiterals.Posting.btnFavoriteInActive, for: .normal)
            header.ghostButton.addTarget(self, action: #selector(transparentShowPopupButton), for: .touchUpInside)

            DispatchQueue.main.async {
                self.postViewHeight = Int(header.PostbackgroundUIView.frame.height)
            }
            // 내가 투명도를 누른 유저인 경우 -85% 적용
            print("\(self.postView.isGhost)")
            print("\(self.postView.memberGhost)")
            
            if self.postView.isGhost {
                print("header == \(header.grayView.alpha)")
                header.grayView.alpha = 0.85
            } else {
                let alpha = self.postView.memberGhost
                header.grayView.alpha = CGFloat(Double(-alpha) / 100)
            }
            
            return header
            
        } else {
            guard let footer = postReplyCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "PostReplyCollectionFooterView", for: indexPath) as? PostReplyCollectionFooterView else { return UICollectionReusableView() }
            return footer
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 24.adjustedH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 8 + postViewHeight.adjusted)
    }
}

extension PostViewController: DontBePopupDelegate {
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
