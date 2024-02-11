//
//  DeleteReplyViewController.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/18/24.
//

import Combine
import UIKit

final class DeleteReplyPopupViewController: UIViewController {
    
    // MARK: - Properties
    
    static let reloadData = NSNotification.Name("reloadData")
    static let showDeleteReplyToastNotification = Notification.Name("ShowDeleteReplyToastNotification")
    
    var commentId: Int = 0
    
    var viewModel: DeleteReplyViewModel
    private var cancelBag = CancelBag()

    // MARK: - UI Components

    private let deleteReplyPopupView = DontBePopupView(popupTitle: "답글 삭제",
                                                      popupContent: StringLiterals.Home.deletePopupCommentLabel,
                                                      leftButtonTitle: StringLiterals.Home.deletePopupLefteftButtonTitle,
                                                      rightButtonTitle: StringLiterals.Home.deletePopupRightButtonTitle)

    private lazy var deleteButtonTapped = deleteReplyPopupView.confirmButton.publisher(for: .touchUpInside).map { _ in
        return self.commentId
    }.eraseToAnyPublisher()
    private lazy var postVC = PostDetailViewController(viewModel: PostDetailViewModel(networkProvider: NetworkService()))

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setHierarchy()
        setLayout()
        setDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        getAPI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.post(name: NSNotification.Name("DismissDetailView"), object: nil, userInfo: nil)
        NotificationCenter.default.post(name: NSNotification.Name("DismissReplyView"), object: nil, userInfo: nil)
    }

    init(viewModel: DeleteReplyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension DeleteReplyPopupViewController {
    
    private func setHierarchy() {
        view.addSubviews(deleteReplyPopupView)
    }

    private func setLayout() {
        deleteReplyPopupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setDelegate() {
        deleteReplyPopupView.delegate = self
    }

    @objc
    private func dismissViewController() {
        self.dismiss(animated: false)
    }
}

// MARK: - Network

extension DeleteReplyPopupViewController {
    private func getAPI() {
        let input = DeleteReplyViewModel.Input(deleteButtonDidTapped: deleteButtonTapped)

        let output = viewModel.transform(from: input, cancelBag: cancelBag)

        output.popView
            .receive(on: RunLoop.main)
            .sink { _ in
                self.dismiss(animated: true)
                // postVC pop
                NotificationCenter.default.post(name: DeleteReplyPopupViewController.reloadData, object: nil)
                self.postVC.postReplyCollectionView.reloadData()
            }
            .store(in: self.cancelBag)
    }
}

extension DeleteReplyPopupViewController: DontBePopupDelegate {
    func cancleButtonTapped() {
        self.dismiss(animated: false)
    }

    func confirmButtonTapped() {
        self.postVC.postReplyCollectionView.reloadData()
        NotificationCenter.default.post(name: DeleteReplyPopupViewController.showDeleteReplyToastNotification, object: nil, userInfo: ["showDeleteToast": true])
    }
}

