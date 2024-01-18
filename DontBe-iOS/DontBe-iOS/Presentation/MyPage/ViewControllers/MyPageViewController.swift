//
//  MyPageViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/11/24.
//

import Combine
import SafariServices
import UIKit

import SnapKit

final class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    let customerCenterURL = URL(string: StringLiterals.MyPage.myPageCustomerURL)
    let feedbackURL = URL(string: StringLiterals.MyPage.myPageFeedbackURL)
    let warnUserURL = URL(string: StringLiterals.Network.warnUserGoogleFormURL)
    
    private var cancelBag = CancelBag()
    var viewModel: MyPageViewModel
    let homeViewModel = HomeViewModel(networkProvider: NetworkService())
    
    var memberId: Int = loadUserData()?.memberId ?? 0
    var contentId: Int = 0
    var alarmTriggerType: String = ""
    var targetMemberId: Int = 0
    var alarmTriggerdId: Int = 0
    
    var currentPage: Int = 0 {
        didSet {
            rootView.myPageScrollView.isScrollEnabled = true
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            rootView.pageViewController.setViewControllers(
                [rootView.dataViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
            rootView.myPageScrollView.setContentOffset(CGPoint(x: 0, y: -rootView.myPageScrollView.contentInset.top - navigationBarHeight - statusBarHeight), animated: true)
            rootView.myPageContentViewController.homeCollectionView.isScrollEnabled = true
            rootView.myPageScrollView.isScrollEnabled = true
        }
    }
    
    var tabBarHeight: CGFloat = 0
    
    // MARK: - UI Components
    
    let rootView = MyPageView()
    
    var deleteBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnDelete)
    var warnBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnWarn)
    
    var transparentPopupVC = TransparentPopupViewController()
    var deletePostPopupVC = DeletePopupViewController(viewModel: DeletePostViewModel(networkProvider: NetworkService()))
    
    private var uploadToastView: DontBeToastView?
    private var alreadyTransparencyToastView: DontBeToastView?
    
    let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
    private var navigationBackButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Common.btnBackGray, for: .normal)
        return button
    }()

   // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAPI()
        setUI()
        setLayout()
        setDelegate()
        setNotification()
        setAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
        bindViewModel()
        let image = ImageLiterals.MyPage.icnMenu
        let renderedImage = image.withRenderingMode(.alwaysOriginal)
        let hambergerButton = UIBarButtonItem(image: renderedImage,
                                              style: .plain,
                                              target: self,
                                              action: #selector(hambergerButtonTapped))
        navigationItem.rightBarButtonItem = hambergerButton
        
        if memberId == loadUserData()?.memberId ?? 0 {
            self.navigationItem.title = StringLiterals.MyPage.MyPageNavigationTitle
            self.tabBarController?.tabBar.isHidden = false
            navigationBackButton.isHidden = true
        } else {
            self.navigationItem.title = ""
            self.tabBarController?.tabBar.isHidden = true
            navigationBackButton.isHidden = false
        }
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donWhite]
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.navigationBar.backgroundColor = .clear
        statusBarView.removeFromSuperview()
        navigationBackButton.removeFromSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeAreaHeight = view.safeAreaInsets.bottom
        let tabBarHeight: CGFloat = 70.0
        
        self.tabBarHeight = tabBarHeight + safeAreaHeight
    }
}

// MARK: - Extensions

extension MyPageViewController {
    private func setUI() {
        self.view.backgroundColor = .donBlack
        self.navigationController?.navigationBar.backgroundColor = .donBlack
        self.navigationController?.navigationBar.barTintColor = .donBlack
        
        transparentPopupVC.modalPresentationStyle = .overFullScreen
        deletePostPopupVC.modalPresentationStyle = .overFullScreen
    }
    
    private func setLayout() {
        self.navigationController?.navigationBar.addSubviews(navigationBackButton)
        navigationBackButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(23.adjusted)
        }
        rootView.pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(rootView.segmentedControl.snp.bottom).offset(2.adjusted)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        rootView.myPageScrollView.delegate = self
        rootView.pageViewController.delegate = self
        rootView.pageViewController.dataSource = self
        transparentPopupVC.transparentButtonPopupView.delegate = self
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(pushViewController), name: MyPageContentViewController.pushViewController, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: MyPageContentViewController.reloadData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(warnUserButtonTapped), name: MyPageContentViewController.reloadData, object: nil)
    }
    
    private func setAddTarget() {
        navigationBackButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        rootView.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        rootView.myPageBottomsheet.profileEditButton.addTarget(self, action: #selector(profileEditButtonTapped), for: .touchUpInside)
        rootView.myPageBottomsheet.accountInfoButton.addTarget(self, action: #selector(accountInfoButtonTapped), for: .touchUpInside)
        rootView.myPageBottomsheet.feedbackButton.addTarget(self, action: #selector(feedbackButtonTapped), for: .touchUpInside)
        rootView.myPageBottomsheet.customerCenterButton.addTarget(self, action: #selector(customerCenterButtonTapped), for: .touchUpInside)
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
    
    private func bindViewModel() {
        let input = MyPageViewModel.Input(viewUpdate: Just((1, self.memberId)).eraseToAnyPublisher())
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.getProfileData
            .receive(on: RunLoop.main)
            .sink { data in
                self.rootView.myPageContentViewController.profileData = self.viewModel.myPageProfileData
                self.rootView.myPageCommentViewController.profileData = self.viewModel.myPageProfileData
                self.bindProfileData(data: data)
            }
            .store(in: self.cancelBag)
        
        output.getContentData
            .receive(on: RunLoop.main)
            .sink { data in
                self.rootView.myPageContentViewController.contentData = data
                if !data.isEmpty {
                    self.rootView.myPageContentViewController.noContentLabel.isHidden = true
                    self.rootView.myPageContentViewController.firstContentButton.isHidden = true
                }
                self.rootView.myPageContentViewController.homeCollectionView.reloadData()
            }
            .store(in: self.cancelBag)
        
        output.getCommentData
            .receive(on: RunLoop.main)
            .sink { data in
                self.rootView.myPageCommentViewController.commentData = data
                if !data.isEmpty {
                    self.rootView.myPageCommentViewController.noCommentLabel.isHidden = true
                }
                self.rootView.myPageCommentViewController.homeCollectionView.reloadData()
            }
            .store(in: self.cancelBag)
    }
    
    private func bindProfileData(data: MypageProfileResponseDTO) {
        self.rootView.myPageProfileView.profileImageView.load(url: data.memberProfileUrl)
        self.rootView.myPageProfileView.userNickname.text = data.nickname
        self.rootView.myPageProfileView.userIntroduction.text = data.memberIntro
        self.rootView.myPageProfileView.transparencyValue = data.memberGhost
        
        if data.memberId != loadUserData()?.memberId ?? 0 {
            self.rootView.myPageContentViewController.noContentLabel.text = "아직 \(data.nickname)" + StringLiterals.MyPage.myPageNoContentOtherLabel
            self.rootView.myPageContentViewController.firstContentButton.isHidden = true
            self.rootView.myPageCommentViewController.noCommentLabel.text = "아직 \(data.nickname)" + StringLiterals.MyPage.myPageNoCommentOtherLabel
        } else {
            self.rootView.myPageContentViewController.noContentLabel.text = "\(data.nickname)" + StringLiterals.MyPage.myPageNoContentLabel
            self.rootView.myPageCommentViewController.noCommentLabel.text = StringLiterals.MyPage.myPageNoCommentLabel
        }
    }
    
    @objc
    private func pushViewController(_ notification: Notification) {
        if let contentId = notification.userInfo?["contentId"] as? Int {
            let destinationViewController = PostViewController(viewModel: PostViewModel(networkProvider: NetworkService()))
            destinationViewController.contentId = contentId
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
    
    @objc
    func reloadData(_ notification: Notification) {
        bindViewModel()
    }
    
    @objc
    private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }
    
    @objc
    private func hambergerButtonTapped() {
        rootView.myPageBottomsheet.showSettings()
    }
    
    @objc
    private func profileEditButtonTapped() {
        rootView.myPageBottomsheet.handleDismiss()
        let vc = MyPageEditProfileViewController(viewModel: MyPageProfileViewModel(networkProvider: NetworkService()))
        vc.nickname = self.rootView.myPageProfileView.userNickname.text ?? ""
        vc.introText = self.rootView.myPageProfileView.userIntroduction.text ?? ""
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc
    private func accountInfoButtonTapped() {
        rootView.myPageBottomsheet.handleDismiss()
        let vc = MyPageAccountInfoViewController(viewModel: self.viewModel)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc
    private func customerCenterButtonTapped() {
        let customerCenterView: SFSafariViewController
        if let customerCenterURL = self.customerCenterURL {
            customerCenterView = SFSafariViewController(url: customerCenterURL)
            self.present(customerCenterView, animated: true, completion: nil)
        }
    }
    
    @objc
    private func feedbackButtonTapped() {
        let feedbackView: SFSafariViewController
        if let feedbackURL = self.feedbackURL {
            feedbackView = SFSafariViewController(url: feedbackURL)
            self.present(feedbackView, animated: true, completion: nil)
        }
    }
    
    @objc
    private func warnUserButtonTapped(_ notification: Notification) {
        print("warnUserButtonTapped")
    }
    
    @objc
    private func deleteButtonTapped() {
        print("deleteButtonTapped")
    }
    
    @objc
    private func transparencyButtonTapped(_ notification: Notification) {
        self.present(self.transparentPopupVC, animated: false, completion: nil)
    }
    
    private func moveTop() {
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        rootView.myPageScrollView.setContentOffset(CGPoint(x: 0, y: -rootView.myPageScrollView.contentInset.top - navigationBarHeight - statusBarHeight), animated: true)
    }
    
    @objc
    private func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Network

extension MyPageViewController {
    private func getAPI() {
        
    }
}

extension MyPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = rootView.dataViewControllers.firstIndex(of: viewController),
            index - 1 >= 0
        else { return nil }
        return rootView.dataViewControllers[index - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = rootView.dataViewControllers.firstIndex(of: viewController),
            index + 1 < rootView.dataViewControllers.count
        else { return nil }
        return rootView.dataViewControllers[index + 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            let viewController = pageViewController.viewControllers?[0],
            let index = rootView.dataViewControllers.firstIndex(of: viewController)
        else { return }
        self.currentPage = index
        rootView.segmentedControl.selectedSegmentIndex = index
    }
}

extension MyPageViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var yOffset = scrollView.contentOffset.y
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        
        scrollView.isScrollEnabled = true
        rootView.myPageContentViewController.homeCollectionView.isScrollEnabled = false
        rootView.myPageCommentViewController.homeCollectionView.isScrollEnabled = false
        
        if yOffset <= -(navigationBarHeight + statusBarHeight) {
            rootView.myPageContentViewController.homeCollectionView.isScrollEnabled = false
            rootView.myPageCommentViewController.homeCollectionView.isScrollEnabled = false
            yOffset = -(navigationBarHeight + statusBarHeight)
            rootView.segmentedControl.frame.origin.y = yOffset + statusBarHeight + navigationBarHeight
            rootView.segmentedControl.snp.remakeConstraints {
                $0.top.equalTo(rootView.myPageProfileView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(54.adjusted)
            }
            
            rootView.pageViewController.view.snp.remakeConstraints {
                $0.top.equalTo(rootView.segmentedControl.snp.bottom).offset(2.adjusted)
                $0.leading.trailing.equalToSuperview()
                let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
                $0.height.equalTo(UIScreen.main.bounds.height - statusBarHeight - navigationBarHeight - self.tabBarHeight)
            }
        } else if yOffset >= (rootView.myPageProfileView.frame.height - statusBarHeight - navigationBarHeight) {
            rootView.segmentedControl.frame.origin.y = yOffset - rootView.myPageProfileView.frame.height + statusBarHeight + navigationBarHeight
            rootView.segmentedControl.snp.remakeConstraints {
                $0.top.equalTo(rootView.myPageProfileView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(54.adjusted)
            }
            
            rootView.pageViewController.view.frame.origin.y = yOffset - rootView.myPageProfileView.frame.height + statusBarHeight + navigationBarHeight + rootView.segmentedControl.frame.height
            
            rootView.pageViewController.view.snp.remakeConstraints {
                $0.top.equalTo(rootView.segmentedControl.snp.bottom).offset(2.adjusted)
                $0.leading.trailing.equalToSuperview()
                let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
                $0.height.equalTo(UIScreen.main.bounds.height - statusBarHeight - navigationBarHeight - self.tabBarHeight)
            }
            
            scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
            
            rootView.myPageContentViewController.homeCollectionView.isScrollEnabled = true
            rootView.myPageContentViewController.homeCollectionView.isUserInteractionEnabled = true
            rootView.myPageCommentViewController.homeCollectionView.isScrollEnabled = true
            rootView.myPageCommentViewController.homeCollectionView.isUserInteractionEnabled = true
        }
    }
}


extension MyPageViewController: DontBePopupDelegate {
    func cancleButtonTapped() {
        self.dismiss(animated: false)
    }
    
    func confirmButtonTapped() {
        self.dismiss(animated: false)
        Task {
            do {
                if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                    let result = try await homeViewModel.postDownTransparency(accessToken: accessToken,
                                                                               alarmTriggerType: self.alarmTriggerType,
                                                                               targetMemberId: self.targetMemberId,
                                                                               alarmTriggerId: self.alarmTriggerdId)
                    self.bindViewModel()
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
