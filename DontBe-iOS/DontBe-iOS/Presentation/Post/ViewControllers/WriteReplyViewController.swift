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
    writeView.writeReplyView.postButton.publisher(for: .touchUpInside).map { _ in
        return (self.writeView.writeReplyView.contentTextView.text ?? "", self.contentId)
    }.eraseToAnyPublisher()
    
    var contentId: Int = 0

    
    // MARK: - UI Components
    
    private let writeView = WriteReplyView()
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
        
        getAPI()
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        setBottomSheet()
        setNavigationBarButtonItem()
        // setAddTarget()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindViewModel()
    }
}

// MARK: - Extensions

extension WriteReplyViewController {
    private func setUI() {
        writeView.backgroundColor = .donWhite
        title = "답글달기"
        cancelReplyPopupVC.modalPresentationStyle = .overFullScreen
    }
    
    private func setHierarchy() {
        
    }
    
    private func setLayout() {
        
    }
    
    private func setDelegate() {
        
    }
//    
//    private func setAddTarget() {
//        writeView.writeReplyView.postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
//    }
    
    private func sendData() {
        NotificationCenter.default.post(name: WriteReplyViewController.showUploadToastNotification, object: nil, userInfo: ["showToast": true])
    }
//    
//    @objc
//    func postButtonTapped() {
//        print("클릭클릭")
//
//    }
//    
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
        let cancelButton = UIBarButtonItem(title: "취소", primaryAction: .init(handler: { _Arg in
            self.present(self.cancelReplyPopupVC, animated: false, completion: nil)
        }))
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
}

// MARK: - Network

extension WriteReplyViewController {
    private func getAPI() {
        
    }
}

//extension ExampleViewController: UICollectionViewDelegate {
//
//}
//
//extension ExampleViewController: UICollectionViewDataSource {
//
//}
//
//extension ExampleViewController: UICollectionViewFlowLayout {
//
//}
