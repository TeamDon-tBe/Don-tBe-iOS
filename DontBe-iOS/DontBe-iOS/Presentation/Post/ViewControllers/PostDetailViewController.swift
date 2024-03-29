//
//  PostDetailViewController.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/12/24.
//

import Combine
import SafariServices
import UIKit

import SnapKit

final class PostDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var postUserNickname = postView.postNicknameLabel.text
    private lazy var postDividerView = postView.horizontalDivierView
    private lazy var ghostButton = postView.ghostButton
    
    let refreshControl = UIRefreshControl()
    
    var deletePostPopupVC = DeletePopupViewController(viewModel: DeletePostViewModel(networkProvider: NetworkService()))
    var deleteReplyPopupVC = DeleteReplyPopupViewController(viewModel: DeleteReplyViewModel(networkProvider: NetworkService()))
    
    var writeReplyVC = WriteReplyViewController(viewModel: WriteReplyViewModel(networkProvider: NetworkService()))
    var writeReplyView = WriteReplyView()
    
    var collectionHeaderView: PostDetailCollectionHeaderView?
    
    let warnUserURL = NSURL(string: "\(StringLiterals.Network.warnUserGoogleFormURL)")
    
    let viewModel: PostDetailViewModel
    private var cancelBag = CancelBag()
    
    private lazy var firstReason = self.transparentReasonView.firstReasonView.radioButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var secondReason = self.transparentReasonView.secondReasonView.radioButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var thirdReason = self.transparentReasonView.thirdReasonView.radioButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var fourthReason = self.transparentReasonView.fourthReasonView.radioButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var fifthReason = self.transparentReasonView.fifthReasonView.radioButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var sixthReason = self.transparentReasonView.sixthReasonView.radioButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    
    var contentId: Int = 0
    var commentId: Int = 0
    var memberId: Int = 0
    var postMemberId: Int = 0
    var alarmTriggerType: String = ""
    var targetMemberId: Int = 0
    var alarmTriggerdId: Int = 0
    var ghostReason: String = ""
    var postViewHeight = 0
    var userNickName: String = ""
    var userProfileURL: String = StringLiterals.Network.baseImageURL
    var contentText: String = ""
    
    // MARK: - UI Components
    
    var deletePostBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnDelete)
    var deleteReplyBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnDelete)
    var warnBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnWarn)
    var transparentReasonView = DontBePopupReasonView()
    
    lazy var postView = PostDetailContentView()
    private lazy var textFieldView = PostReplyTextFieldView()
    var postReplyCollectionView = PostReplyCollectionView().collectionView
    private lazy var greenTextField = textFieldView.greenTextFieldView
    private var uploadToastView: DontBeToastView?
    private var alreadyTransparencyToastView: DontBeToastView?
    private var deleteToastView: DontBeDeletePopupView?
    
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddTarget()
        setUI()
        setHierarchy()
        setDelegate()
        setTextFieldGesture()
        setRefreshControll()
        setLayout()
    }
    
    init(viewModel: PostDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = StringLiterals.Post.navigationTitleLabel
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        self.tabBarController?.tabBar.isHidden = false
        
        let backButton = UIBarButtonItem.backButton(target: self, action: #selector(backButtonPressed))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        self.textFieldView.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(56.adjusted)
        }
        
        getAPI()
        setAppearNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("likeButtonTapped"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("profileButtonTapped"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("headerKebabButtonTapped"), object: nil)
        NotificationCenter.default.removeObserver(self, name: DeleteReplyPopupViewController.showDeleteReplyToastNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("DismissReplyView"), object: nil
        )
        NotificationCenter.default.removeObserver(self, name: WriteReplyViewController.showUploadToastNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: CancelReplyPopupViewController.popViewController, object: nil)
    }
}

// MARK: - Extensions

extension PostDetailViewController {
    private func setUI() {
        self.view.backgroundColor = .donWhite
        textFieldView.isUserInteractionEnabled = true
        deletePostPopupVC.modalPresentationStyle = .overFullScreen
        deleteReplyPopupVC.modalPresentationStyle = .overFullScreen
    }
    
    private func setHierarchy() {
        view.addSubviews(postReplyCollectionView,
                         textFieldView)
    }
    
    private func setLayout() {
        
        postReplyCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(textFieldView.snp.bottom).offset(-56.adjusted)
            $0.leading.trailing.equalToSuperview()
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
        transparentReasonView.delegate = self
    }
    
    private func setAppearNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissDetailNotification(_:)), name: NSNotification.Name("DismissReplyView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showToast(_:)), name: WriteReplyViewController.showUploadToastNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissViewController), name: CancelReplyPopupViewController.popViewController, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.likeButtonAction), name: NSNotification.Name("likeButtonTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.profileButtonAction), name: NSNotification.Name("profileButtonTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.headerKebabButtonAction), name: NSNotification.Name("headerKebabButtonTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showDeleteToast(_:)), name: DeleteReplyPopupViewController.showDeleteReplyToastNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(backButtonPressed), name: DeletePopupViewController.showDeletePostToastNotification, object: nil)
    }
    
    @objc func didDismissDetailNotification(_ notification: Notification) {
        DispatchQueue.main.async {
            self.getAPI()
        }
    }
    
    private func setRefreshControll() {
        refreshControl.addTarget(self, action: #selector(refreshPostDidDrag), for: .valueChanged)
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
                
                UIView.animate(withDuration: 1.0, delay: 2, options: .curveEaseIn) {
                    self.uploadToastView?.alpha = 0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
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
            
            UIView.animate(withDuration: 1.0, delay: 1, options: .curveEaseIn) {
                self.alreadyTransparencyToastView?.alpha = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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
        if self.postMemberId == loadUserData()?.memberId ?? 0 {
            self.deleteReplyBottomsheet.showSettings()
            addDeleteReplyButtonAction()
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
        
        let input = PostDetailViewModel.Input(viewUpdate: nil,
                                              likeButtonTapped: likeButtonTapped,
                                              collectionViewUpdata: nil,
                                              commentLikeButtonTapped: nil,
                                              firstReasonButtonTapped: nil,
                                              secondReasonButtonTapped: nil,
                                              thirdReasonButtonTapped: nil,
                                              fourthReasonButtonTapped: nil,
                                              fifthReasonButtonTapped: nil,
                                              sixthReasonButtonTapped: nil)
        
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
    
    @objc
    func headerKebabButtonAction() {
        if self.postMemberId == loadUserData()?.memberId ?? 0 {
            self.deletePostBottomsheet.showSettings()
            addDeletePostButtonAction()
        } else {
            self.warnBottomsheet.showSettings()
            addWarnUserButtonAction()
        }
    }
    
    private func addDeletePostButtonAction() {
        self.deletePostBottomsheet.warnButton.removeFromSuperview()
        self.deletePostBottomsheet.deleteButton.addTarget(self, action: #selector(deletePostButtonDidTapped), for: .touchUpInside)
    }
    
    private func addDeleteReplyButtonAction() {
        self.deleteReplyBottomsheet.warnButton.removeFromSuperview()
        self.deleteReplyBottomsheet.deleteButton.addTarget(self, action: #selector(deleteReply), for: .touchUpInside)
    }
    
    private func addWarnUserButtonAction() {
        self.warnBottomsheet.deleteButton.removeFromSuperview()
        self.warnBottomsheet.warnButton.addTarget(self, action: #selector(warnUser), for: .touchUpInside)
    }
    
    @objc
    func deletePostButtonDidTapped() {
        popPostView()
        deletePostPopupView()
    }
    
    @objc
    func deleteReply() {
        popReplyView()
        deleteReplyPopupView()
    }
    
    @objc
    private func warnUser() {
        popWarnView()
        let safariView: SFSafariViewController = SFSafariViewController(url: self.warnUserURL! as URL)
        self.present(safariView, animated: true, completion: nil)
    }
    
    @objc
    private func pushToMypage() {
        if self.postMemberId == loadUserData()?.memberId ?? 0  {
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
            viewController.memberId = postMemberId
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    @objc
    private func pushToOtherUserPage() {
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
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    @objc
    func showDeleteToast(_ notification: Notification) {
        if let showToast = notification.userInfo?["showDeleteToast"] as? Bool {
            if showToast == true {
                DispatchQueue.main.async {
                    self.deleteToastView = DontBeDeletePopupView()
                    
                    self.view.addSubviews(self.deleteToastView ?? DontBeDeletePopupView())
                    
                    self.deleteToastView?.snp.makeConstraints {
                        $0.leading.trailing.equalToSuperview().inset(24.adjusted)
                        $0.centerY.equalTo(self.view.safeAreaLayoutGuide)
                        $0.height.equalTo(75.adjusted)
                    }
                    
                    UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseIn) {
                        self.deleteToastView?.alpha = 0
                    }
                }
            }
        }
    }
    
    func popPostView() {
        if UIApplication.shared.keyWindowInConnectedScenes != nil {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.deletePostBottomsheet.dimView.alpha = 0
                self.postView.deletePostBottomsheetView.dimView.alpha = 0
                if let window = UIApplication.shared.keyWindowInConnectedScenes {
                    self.deletePostBottomsheet.bottomsheetView.frame = CGRect(x: 0, y: window.frame.height, width: self.deleteReplyBottomsheet.frame.width, height: self.deletePostBottomsheet.bottomsheetView.frame.height)
                    self.postView.deletePostBottomsheetView.bottomsheetView.frame = CGRect(x: 0, y: window.frame.height, width: self.postView.deletePostBottomsheetView.frame.width, height: self.postView.deletePostBottomsheetView.bottomsheetView.frame.height)
                }
            })
            deletePostBottomsheet.dimView.removeFromSuperview()
            deletePostBottomsheet.bottomsheetView.removeFromSuperview()
            postView.deletePostBottomsheetView.dimView.removeFromSuperview()
            postView.deletePostBottomsheetView.bottomsheetView.removeFromSuperview()
        }
    }
    
    func popReplyView() {
        if UIApplication.shared.keyWindowInConnectedScenes != nil {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.deleteReplyBottomsheet.dimView.alpha = 0
                self.postView.deletePostBottomsheetView.dimView.alpha = 0
                if let window = UIApplication.shared.keyWindowInConnectedScenes {
                    self.deleteReplyBottomsheet.bottomsheetView.frame = CGRect(x: 0, y: window.frame.height, width: self.deleteReplyBottomsheet.frame.width, height: self.deleteReplyBottomsheet.bottomsheetView.frame.height)
                    self.postView.deletePostBottomsheetView.bottomsheetView.frame = CGRect(x: 0, y: window.frame.height, width: self.postView.deletePostBottomsheetView.frame.width, height: self.postView.deletePostBottomsheetView.bottomsheetView.frame.height)
                }
            })
            deleteReplyBottomsheet.dimView.removeFromSuperview()
            deleteReplyBottomsheet.bottomsheetView.removeFromSuperview()
            postView.deletePostBottomsheetView.dimView.removeFromSuperview()
            postView.deletePostBottomsheetView.bottomsheetView.removeFromSuperview()
        }
    }
    
    func popWarnView() {
        if UIApplication.shared.keyWindowInConnectedScenes != nil {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.deleteReplyBottomsheet.dimView.alpha = 0
                self.postView.deletePostBottomsheetView.dimView.alpha = 0
                if let window = UIApplication.shared.keyWindowInConnectedScenes {
                    self.deleteReplyBottomsheet.bottomsheetView.frame = CGRect(x: 0, y: window.frame.height, width: self.deleteReplyBottomsheet.frame.width, height: self.deleteReplyBottomsheet.bottomsheetView.frame.height)
                    self.postView.deletePostBottomsheetView.bottomsheetView.frame = CGRect(x: 0, y: window.frame.height, width: self.postView.deletePostBottomsheetView.frame.width, height: self.postView.deletePostBottomsheetView.bottomsheetView.frame.height)
                }
            })
            warnBottomsheet.dimView.removeFromSuperview()
            warnBottomsheet.bottomsheetView.removeFromSuperview()
            postView.warnUserBottomsheetView.dimView.removeFromSuperview()
            postView.warnUserBottomsheetView.bottomsheetView.removeFromSuperview()
        }
    }
    
    func deletePostPopupView() {
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
        
        if let window = UIApplication.shared.keyWindowInConnectedScenes {
            window.addSubviews(self.transparentReasonView)
            
            self.transparentReasonView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            let radioButtonImage = ImageLiterals.TransparencyInfo.btnRadio
            
            self.transparentReasonView.firstReasonView.radioButton.setImage(radioButtonImage, for: .normal)
            self.transparentReasonView.secondReasonView.radioButton.setImage(radioButtonImage, for: .normal)
            self.transparentReasonView.thirdReasonView.radioButton.setImage(radioButtonImage, for: .normal)
            self.transparentReasonView.fourthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
            self.transparentReasonView.fifthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
            self.transparentReasonView.sixthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
            self.transparentReasonView.warnLabel.isHidden = true
            self.ghostReason = ""
        }
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
        viewController.userProfileImage = self.postView.profileImageView.image ?? ImageLiterals.Common.imgProfile
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc
    func refreshPostDidDrag() {
        DispatchQueue.main.async {
            self.getAPI()
        }
    }
    
    @objc
    func finishedRefreshing() {
        refreshControl.endRefreshing()
    }
    
    @objc
    private func dismissViewController() {
        self.dismiss(animated: false)
    }
}

// MARK: - Network

extension PostDetailViewController {
    private func getAPI() {
        let input = PostDetailViewModel.Input(viewUpdate: Just((contentId)).eraseToAnyPublisher(),
                                              likeButtonTapped: nil,
                                              collectionViewUpdata: Just((contentId)).eraseToAnyPublisher(),
                                              commentLikeButtonTapped: nil,
                                              firstReasonButtonTapped: firstReason,
                                              secondReasonButtonTapped: secondReason,
                                              thirdReasonButtonTapped: thirdReason,
                                              fourthReasonButtonTapped: fourthReason,
                                              fifthReasonButtonTapped: fifthReason,
                                              sixthReasonButtonTapped: sixthReason)
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.getPostData
            .receive(on: RunLoop.main)
            .sink { data in
                self.postMemberId = data.memberId
                self.bindPostData(data: data)
                self.postReplyCollectionView.reloadData()
                self.perform(#selector(self.finishedRefreshing), with: nil, afterDelay: 0.1)
            }
            .store(in: self.cancelBag)
        
        output.getPostReplyData
            .receive(on: RunLoop.main)
            .sink { data in
                self.postReplyCollectionView.reloadData()
            }
            .store(in: self.cancelBag)
        
        output.clickedButtonState
            .sink { [weak self] index in
                guard let self = self else { return }
                let radioSelectedButtonImage = ImageLiterals.TransparencyInfo.btnRadioSelected
                let radioButtonImage = ImageLiterals.TransparencyInfo.btnRadio
                self.transparentReasonView.warnLabel.isHidden = true
                
                switch index {
                case 1:
                    self.transparentReasonView.firstReasonView.radioButton.setImage(radioSelectedButtonImage, for: .normal)
                    self.transparentReasonView.secondReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.thirdReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.fourthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.fifthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.sixthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    ghostReason = self.transparentReasonView.firstReasonView.reasonLabel.text ?? ""
                case 2:
                    self.transparentReasonView.firstReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.secondReasonView.radioButton.setImage(radioSelectedButtonImage, for: .normal)
                    self.transparentReasonView.thirdReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.fourthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.fifthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.sixthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    ghostReason = self.transparentReasonView.secondReasonView.reasonLabel.text ?? ""
                case 3:
                    self.transparentReasonView.firstReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.secondReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.thirdReasonView.radioButton.setImage(radioSelectedButtonImage, for: .normal)
                    self.transparentReasonView.fourthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.fifthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.sixthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    ghostReason = self.transparentReasonView.thirdReasonView.reasonLabel.text ?? ""
                case 4:
                    self.transparentReasonView.firstReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.secondReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.thirdReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.fourthReasonView.radioButton.setImage(radioSelectedButtonImage, for: .normal)
                    self.transparentReasonView.fifthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.sixthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    ghostReason = self.transparentReasonView.fourthReasonView.reasonLabel.text ?? ""
                case 5:
                    self.transparentReasonView.firstReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.secondReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.thirdReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.fourthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.fifthReasonView.radioButton.setImage(radioSelectedButtonImage, for: .normal)
                    self.transparentReasonView.sixthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    ghostReason = self.transparentReasonView.fifthReasonView.reasonLabel.text ?? ""
                case 6:
                    self.transparentReasonView.firstReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.secondReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.thirdReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.fourthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.fifthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.transparentReasonView.sixthReasonView.radioButton.setImage(radioSelectedButtonImage, for: .normal)
                    ghostReason = self.transparentReasonView.sixthReasonView.reasonLabel.text ?? ""
                default:
                    break
                }
            }
            .store(in: self.cancelBag)
    }
    
    private func bindPostData(data: PostDetailResponseDTO) {
        self.postView.isGhost = data.isGhost
        self.postView.memberGhost = data.memberGhost
        self.postView.isDeleted = data.isDeleted
        
        self.collectionHeaderView?.profileImageView.load(url: data.memberProfileUrl)
        self.textFieldView.replyTextFieldLabel.text = "\(data.memberNickname)" + StringLiterals.Post.textFieldLabel
        self.postView.postNicknameLabel.text = data.memberNickname
        self.postUserNickname = "\(data.memberNickname)"
        self.userNickName = "\(data.memberNickname)"
        self.postView.contentTextLabel.text = data.contentText
        self.postView.transparentLabel.text = "투명도 \(data.memberGhost)%"
        self.postView.timeLabel.text = data.time.formattedTime()
        self.postView.likeNumLabel.text = "\(data.likedNumber)"
        self.postView.commentNumLabel.text = "\(data.commentNumber)"
        self.postView.profileImageView.load(url: "\(data.memberProfileUrl)")
        postView.likeButton.setImage(data.isLiked ? ImageLiterals.Posting.btnFavoriteActive : ImageLiterals.Posting.btnFavoriteInActive, for: .normal)
        self.postMemberId = data.memberId
        self.postView.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushToMypage)))
        self.postView.isLiked = data.isLiked
        
        self.userNickName = "\(data.memberNickname)"
        self.contentText = "\(data.contentText)"
        
        // 내가 투명도를 누른 유저인 경우 -85% 적용
        if data.isGhost {
            self.collectionHeaderView?.grayView.alpha = 0.85
        } else {
            let alpha = data.memberGhost
            self.collectionHeaderView?.grayView.alpha = CGFloat(Double(-alpha) / 100)
        }
        
        if self.postMemberId == loadUserData()?.memberId {
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
        
        let input = PostDetailViewModel.Input(viewUpdate: nil,
                                              likeButtonTapped: nil,
                                              collectionViewUpdata: nil,
                                              commentLikeButtonTapped: commentLikedButtonTapped,
                                              firstReasonButtonTapped: firstReason,
                                              secondReasonButtonTapped: secondReason,
                                              thirdReasonButtonTapped: thirdReason,
                                              fourthReasonButtonTapped: fourthReason,
                                              fifthReasonButtonTapped: fifthReason,
                                              sixthReasonButtonTapped: sixthReason)
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.toggleLikeButton
            .sink { _ in }
            .store(in: self.cancelBag)
    }
}

extension PostDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.postReplyDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        PostReplyCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
        
        cell.alarmTriggerType = "commentGhost"
        cell.targetMemberId = viewModel.postReplyDatas[indexPath.row].memberId
        cell.alarmTriggerdId = viewModel.postReplyDatas[indexPath.row].commentId
        cell.nicknameLabel.text = viewModel.postReplyDatas[indexPath.row].memberNickname
        
        if viewModel.postReplyDatas[indexPath.row].memberId == loadUserData()?.memberId {
            cell.ghostButton.isHidden = true
            cell.verticalTextBarView.isHidden = true
            self.deleteReplyBottomsheet.warnButton.removeFromSuperview()
            
            cell.KebabButtonAction = {
                self.deleteReplyBottomsheet.showSettings()
                self.deleteReplyBottomsheet.deleteButton.addTarget(self, action: #selector(self.deleteReply), for: .touchUpInside)
                self.commentId = self.viewModel.postReplyDatas[indexPath.row].commentId
            }
        } else {
            cell.ghostButton.isHidden = false
            cell.verticalTextBarView.isHidden = false
            self.warnBottomsheet.deleteButton.removeFromSuperview()
            
            cell.KebabButtonAction = {
                self.warnBottomsheet.showSettings()
                self.warnBottomsheet.warnButton.addTarget(self, action: #selector(self.warnUser), for: .touchUpInside)
                self.commentId = self.viewModel.postReplyDatas[indexPath.row].commentId
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
            
            self.postCommentLikeButtonAPI(isClicked: cell.isLiked, commentId: self.viewModel.postReplyDatas[indexPath.row].commentId, commentText: self.viewModel.postReplyDatas[indexPath.row].commentText)
        }
        cell.TransparentButtonAction = {
            self.alarmTriggerType = cell.alarmTriggerType
            self.targetMemberId = cell.targetMemberId
            self.alarmTriggerdId = cell.alarmTriggerdId
            
            if let window = UIApplication.shared.keyWindowInConnectedScenes {
                window.addSubviews(self.transparentReasonView)
                
                self.transparentReasonView.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
                
                let radioButtonImage = ImageLiterals.TransparencyInfo.btnRadio
                
                self.transparentReasonView.firstReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                self.transparentReasonView.secondReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                self.transparentReasonView.thirdReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                self.transparentReasonView.fourthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                self.transparentReasonView.fifthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                self.transparentReasonView.sixthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                self.transparentReasonView.warnLabel.isHidden = true
                self.ghostReason = ""
            }
        }
        cell.ProfileButtonAction = {
            self.memberId = self.viewModel.postReplyDatas[indexPath.row].memberId
            self.pushToOtherUserPage()
        }
        cell.nicknameLabel.text = viewModel.postReplyDatas[indexPath.row].memberNickname
        cell.transparentLabel.text = "투명도 \(viewModel.postReplyDatas[indexPath.row].memberGhost)%"
        cell.contentTextLabel.text = viewModel.postReplyDatas[indexPath.row].commentText
        cell.likeNumLabel.text = "\(viewModel.postReplyDatas[indexPath.row].commentLikedNumber)"
        cell.timeLabel.text = "\(viewModel.postReplyDatas[indexPath.row].time.formattedTime())"
        cell.profileImageView.load(url: "\(viewModel.postReplyDatas[indexPath.row].memberProfileUrl)")
        self.commentId = viewModel.postReplyDatas[indexPath.row].commentId
        cell.likeButton.setImage(viewModel.postReplyDatas[indexPath.row].isLiked ? ImageLiterals.Posting.btnFavoriteActive : ImageLiterals.Posting.btnFavoriteInActive, for: .normal)
        cell.isLiked = self.viewModel.postReplyDatas[indexPath.row].isLiked
        // 내가 투명도를 누른 유저인 경우 -85% 적용
        if self.viewModel.postReplyDatas[indexPath.row].isGhost {
            cell.grayView.alpha = 0.85
        } else {
            let alpha = self.viewModel.postReplyDatas[indexPath.row].memberGhost
            cell.grayView.alpha = CGFloat(Double(-alpha) / 100)
        }
        
        // 탈퇴한 회원 닉네임 텍스트 색상 변경, 프로필로 이동 못하도록 적용
        if self.viewModel.postReplyDatas[indexPath.row].isDeleted {
            cell.nicknameLabel.textColor = .donGray12
            cell.profileImageView.isUserInteractionEnabled = false
        } else {
            cell.nicknameLabel.textColor = .donBlack
            cell.profileImageView.isUserInteractionEnabled = true
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PostCollectionViewHeader", for: indexPath) as? PostDetailCollectionHeaderView
            else { return UICollectionReusableView()
            }
            
            if self.postMemberId == loadUserData()?.memberId {
                header.ghostButton.isHidden = true
                header.verticalTextBarView.isHidden = true
            } else {
                header.ghostButton.isHidden = false
                header.verticalTextBarView.isHidden = true
            }
            
            header.transparentLabel.text = self.postView.transparentLabel.text
            header.postNicknameLabel.text = self.postView.postNicknameLabel.text
            header.timeLabel.text = self.postView.timeLabel.text
            header.contentTextLabel.text = self.postView.contentTextLabel.text
            header.likeNumLabel.text = self.postView.likeNumLabel.text
            header.commentNumLabel.text = self.postView.commentNumLabel.text
            header.isLiked = self.postView.isLiked
            header.likeButton.setImage(header.isLiked ? ImageLiterals.Posting.btnFavoriteActive : ImageLiterals.Posting.btnFavoriteInActive, for: .normal)
            header.ghostButton.addTarget(self, action: #selector(transparentShowPopupButton), for: .touchUpInside)
            header.profileImageView.load(url: self.userProfileURL)
            
            DispatchQueue.main.async {
                self.postViewHeight = Int(header.PostbackgroundUIView.frame.height)
            }
            
            // 내가 투명도를 누른 유저인 경우 -85% 적용
            if self.postView.isGhost {
                header.grayView.alpha = 0.85
            } else {
                let alpha = self.postView.memberGhost
                header.grayView.alpha = CGFloat(Double(-alpha) / 100)
            }
            
            // 탈퇴한 회원 닉네임 텍스트 색상 변경, 프로필로 이동 못하도록 적용
            if self.postView.isDeleted {
                header.postNicknameLabel.textColor = .donGray12
                header.profileImageView.isUserInteractionEnabled = false
            } else {
                header.postNicknameLabel.textColor = .donBlack
                header.profileImageView.isUserInteractionEnabled = true
            }
            
            return header
            
        } else {
            guard let footer = postReplyCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "PostReplyCollectionFooterView", for: indexPath) as? PostDetailCollectionFooterView else { return UICollectionReusableView() }
            return footer
            
        }
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    //
    //        return CGSize(width: UIScreen.main.bounds.width, height: 24.adjustedH)
    //    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == postReplyCollectionView {
            if (scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height) {
                let lastCommentId = viewModel.postReplyDatas.last?.commentId ?? -1
                viewModel.cursor = lastCommentId
                getAPI()
                DispatchQueue.main.async {
                    self.postReplyCollectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 1 + postViewHeight.adjusted)
    }
}

extension PostDetailViewController: DontBePopupReasonDelegate {
    func reasonCancelButtonTapped() {
        transparentReasonView.removeFromSuperview()
    }
    
    func reasonConfirmButtonTapped() {
        if self.ghostReason == "" {
            self.transparentReasonView.warnLabel.isHidden = false
        } else {
            transparentReasonView.removeFromSuperview()
            
            Task {
                do {
                    if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                        let result = try await self.viewModel.postDownTransparency(accessToken: accessToken,
                                                                                   alarmTriggerType: self.alarmTriggerType,
                                                                                   targetMemberId: self.targetMemberId,
                                                                                   alarmTriggerId: self.alarmTriggerdId,
                                                                                   ghostReason: self.ghostReason)
                        refreshPostDidDrag()
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
}
