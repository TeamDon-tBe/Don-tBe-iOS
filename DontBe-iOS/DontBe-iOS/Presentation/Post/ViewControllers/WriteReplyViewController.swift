//
//  WriteReplyViewController.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/14/24.
//

import UIKit

final class WriteReplyViewController: UIViewController {
    
    // MARK: - Properties
    
    static let showUploadToastNotification = Notification.Name("ShowUploadToastNotification")
    
    private var cancelBag = CancelBag()
    private let viewModel: WriteReplyViewModel
    
    private lazy var postButtonTapped =
    writeView.postButton.publisher(for: .touchUpInside).map { _ in
        return (self.writeView.writeReplyView.contentTextView.text ?? "", self.contentId)
    }.eraseToAnyPublisher()
    
    var contentId: Int = 0
    var tabBarHeight: CGFloat = 0
    var userNickname: String = ""
    var userProfileImage: UIImage = ImageLiterals.Common.imgProfile
    var userContent: String = ""
    
    // MARK: - UI Components
    
    let writeView = WriteReplyView()
    private lazy var cancelReplyPopupVC = CancelReplyPopupViewController()
    
    // MARK: - Life Cycles
    
    init(viewModel: WriteReplyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setBottomSheet()
        setNavigationBarButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("DismissReplyView"), object: nil, userInfo: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeAreaHeight = view.safeAreaInsets.bottom
        let tabBarHeight: CGFloat = 70.0
        
        self.tabBarHeight = tabBarHeight + safeAreaHeight
    }
}

// MARK: - Extensions

extension WriteReplyViewController {
    private func setUI() {
        writeView.backgroundColor = .donWhite
        title = "답글달기"
        cancelReplyPopupVC.modalPresentationStyle = .overFullScreen
        
        writeView.writeReplyPostview.postNicknameLabel.text = self.userNickname
        writeView.writeReplyPostview.contentTextLabel.text = self.userContent
        writeView.writeReplyPostview.profileImageView.image = self.userProfileImage
    }
    
    private func sendData() {
        NotificationCenter.default.post(name: WriteReplyViewController.showUploadToastNotification, object: nil, userInfo: ["showToast": true])
    }
    
    private func bindViewModel() {
        let input = WriteReplyViewModel.Input(postButtonTapped: postButtonTapped)
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.popViewController
            .sink { _ in
                DispatchQueue.main.async {
                    self.popupNavigation()
                    self.sendData()
                }
            }
            .store(in: self.cancelBag)
    }
    
    private func popupNavigation() {
        self.dismiss(animated: true)
    }
    
    private func setBottomSheet() {
        /// 밑으로 내려도 dismiss되지 않는 옵션 값
        isModalInPresentation = true
        
        if let sheet = sheetPresentationController {
            sheet.detents = [.large()]
            sheet.selectedDetentIdentifier = .large
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.prefersGrabberVisible = false
        }
    }
    
    private func setNavigationBarButtonItem() {
        let cancelButton = UIBarButtonItem(
            title: StringLiterals.Write.writeNavigationBarButtonItemTitle,
            style: .plain,
            target: self,
            action: #selector(cancleNavigationBarButtonTapped)
        )
        navigationItem.leftBarButtonItem = cancelButton
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.donGray11,
            .font: UIFont.font(.caption4)
        ]
        cancelButton.setTitleTextAttributes(attributes, for: .normal)
        cancelButton.setTitleTextAttributes(attributes, for: .highlighted)
    }
    
    public func dismissView() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func cancleNavigationBarButtonTapped() {
        // 텍스트가 비어있는 경우 POP
        if self.writeView.writeReplyView.contentTextView.text == "" {
            popupNavigation()
        } else {
            self.present(self.cancelReplyPopupVC, animated: false, completion: nil)
        }
    }
}
