//
//  PostViewController.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/12/24.
//

import UIKit
import Combine

final class PostViewController: UIViewController {
    
    // MARK: - Properties
    var tabBarHeight: CGFloat = 0
    private lazy var postUserNickname = postView.postNicknameLabel.text
    private lazy var postDividerView = postView.horizontalDivierView
    private lazy var ghostButton = postView.ghostButton
    var deleteBottomsheet = DontBeBottomSheetView(singleButtonImage: ImageLiterals.Posting.btnDelete)
    var transparentPopupVC = TransparentPopupViewController()
    var deletePostPopupVC = CancelReplyPopupViewController()
    private var likeButtonTappedPublisher: AnyPublisher<Int, Never> {
        return postView.likeButton.publisher(for: .touchUpInside)
            .map { _ in return self.contentId }
            .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: false)
            .eraseToAnyPublisher()
    }
    
    
    let viewModel: PostViewModel
    private var cancelBag = CancelBag()
    
    var contentId: Int = 0
    
    // MARK: - UI Components
    
    private lazy var myView = PostDetailView()
    private lazy var postView = PostView()
    private lazy var textFieldView = PostReplyTextFieldView()
    private lazy var postReplyCollectionView = PostReplyCollectionView().collectionView
    private lazy var greenTextField = textFieldView.greenTextFieldView
    private var uploadToastView: DontBeToastView?
    
    private let verticalBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray3
        return view
    }()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = myView
        self.navigationController?.navigationBar.isHidden = false
        textFieldView.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        setTextFieldGesture()
        setNotification()
        setAddTarget()
    }
    
    init(viewModel: PostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - TabBar Height
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        
        let backButton = UIBarButtonItem.backButton(target: self, action: #selector(backButtonPressed))
        self.navigationItem.leftBarButtonItem = backButton
        
        getAPI()
    }
}

// MARK: - Extensions

extension PostViewController {
    private func setUI() {
        self.navigationItem.title = StringLiterals.Post.navigationTitleLabel
        textFieldView.replyTextFieldLabel.text = (postUserNickname ?? "") + StringLiterals.Post.textFieldLabel
        
        self.view.backgroundColor = .donWhite
        
        transparentPopupVC.modalPresentationStyle = .overFullScreen
        deletePostPopupVC.modalPresentationStyle = .overFullScreen
    }
    
    private func setHierarchy() {
        view.addSubviews(postView,
                         verticalBarView,
                         postReplyCollectionView,
                         textFieldView)
    }
    
    private func setLayout() {
        postView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        postReplyCollectionView.snp.makeConstraints {
            $0.top.equalTo(postView.horizontalDivierView.snp.bottom).offset(10)
            $0.bottom.equalTo(textFieldView.snp.bottom).offset(-56.adjusted)
            $0.leading.equalTo(verticalBarView.snp.trailing)
            $0.trailing.equalToSuperview().inset(16.adjusted)
        }
        
        verticalBarView.snp.makeConstraints {
            $0.top.equalTo(postReplyCollectionView)
            $0.leading.equalToSuperview().inset(16.adjusted)
            $0.width.equalTo(1.adjusted)
            $0.bottom.equalTo(postReplyCollectionView.snp.bottom)
        }
        
        textFieldView.snp.makeConstraints {
            $0.bottom.equalTo(tabBarHeight.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56.adjusted)
        }
    }
    
    private func setDelegate() {
        postReplyCollectionView.dataSource = self
        postReplyCollectionView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissViewController), name: CancelReplyPopupViewController.popViewController, object: nil)
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showToast(_:)), name: WriteReplyViewController.showUploadToastNotification, object: nil)
    }
    
    @objc func showToast(_ notification: Notification) {
        if let showToast = notification.userInfo?["showToast"] as? Bool {
            if showToast == true {
                
                uploadToastView = DontBeToastView()
                
                view.addSubviews(uploadToastView ?? DontBeToastView())
                
                uploadToastView?.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview().inset(16.adjusted)
                    $0.bottom.equalTo(tabBarHeight.adjusted).inset(6.adjusted)
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
    
    @objc
    private func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setAddTarget() {
        ghostButton.addTarget(self, action: #selector(transparentShowPopupButton), for: .touchUpInside)
        deleteBottomsheet.deleteButton.addTarget(self, action: #selector(deletePost), for: .touchUpInside)
        postView.deleteBottomsheet.deleteButton.addTarget(self, action: #selector(deletePost), for: .touchUpInside)
    }
    
    @objc
    func deletePost() {
        popView()
        presentView()
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
        self.present(self.deletePostPopupVC, animated: false, completion: nil)
    }
    
    @objc
    func transparentShowPopupButton() {
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
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc
    private func dismissViewController() {
        self.dismiss(animated: false)
    }
    
}

// MARK: - Network

extension PostViewController {
    private func getAPI() {
        let input = PostViewModel.Input(viewUpdate: Just((contentId)).eraseToAnyPublisher(), likeButtonTapped: likeButtonTappedPublisher)
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.getPostData
            .receive(on: RunLoop.main)
            .sink { data in
                self.bindPostData(data: data)
            }
            .store(in: self.cancelBag)
        
        output.toggleLikeButton
            .receive(on: RunLoop.main)
            .sink { value in
                if value {
                    self.postView.likeNumLabel.text = String((Int(self.postView.likeNumLabel.text ?? "") ?? 0) + 1)
                    self.postView.likeButton.setImage(ImageLiterals.Posting.btnFavoriteActive, for: .normal)
                } else {
                    self.postView.likeNumLabel.text = String((Int(self.postView.likeNumLabel.text ?? "") ?? 0) - 1)
                    self.postView.likeButton.setImage(ImageLiterals.Posting.btnFavoriteInActive, for: .normal)
                }
            }
            .store(in: self.cancelBag)
    }
    
    private func bindPostData(data: PostDetailResponseDTO) {
        self.postView.postNicknameLabel.text = data.memberNickname
        self.postView.contentTextLabel.text = data.contentText
        self.postView.transparentLabel.text = "투명도 \(data.memberGhost)%"
        self.postView.timeLabel.text = data.time.formattedTime()
        self.postView.likeNumLabel.text = "\(data.likedNumber)"
        self.postView.commentNumLabel.text = "\(data.commentNumber)"
        postView.likeButton.setImage(data.isLiked ? ImageLiterals.Posting.btnFavoriteActive : ImageLiterals.Posting.btnFavoriteInActive, for: .normal)
    }
}

extension PostViewController: UICollectionViewDelegate { }

extension PostViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        PostReplyCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
        
        cell.KebabButtonAction = {
                    self.deleteBottomsheet.showSettings()
                }
                cell.LikeButtonAction = {
                    cell.isLiked.toggle()
                    cell.likeButton.setImage(cell.isLiked ? ImageLiterals.Posting.btnFavoriteActive : ImageLiterals.Posting.btnFavoriteInActive, for: .normal)
                }
                cell.TransparentButtonAction = {
                    // present
                    self.present(self.transparentPopupVC, animated: false, completion: nil)
                }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = postReplyCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "PostReplyCollectionFooterView", for: indexPath) as? PostReplyCollectionFooterView else { return UICollectionReusableView() }
        footer.backgroundColor = .red
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 24.adjusted)
    }
}
