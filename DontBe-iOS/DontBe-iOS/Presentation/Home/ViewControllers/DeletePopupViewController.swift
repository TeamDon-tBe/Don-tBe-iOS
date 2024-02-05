//
//  DeletePopupViewController.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/15/24.
//

import Combine
import UIKit

final class DeletePopupViewController: UIViewController {
    
    // MARK: - Properties
    
    var contentId: Int = 0
    
    static let popViewController = NSNotification.Name("popVC")
    static let reloadData = NSNotification.Name("reloadData")
    static let showWriteToastNotification = Notification.Name("ShowWriteToastNotification")
    static let showDeletePostToastNotification = Notification.Name("ShowDeletePostToastNotification")
    
    var viewModel: DeletePostViewModel
    private var cancelBag = CancelBag()
    
    private lazy var deleteButtonTapped = deletePostPopupView.confirmButton.publisher(for: .touchUpInside).map { _ in
        return self.contentId
    }.eraseToAnyPublisher()
    
    private lazy var homeVC = HomeViewController(viewModel: HomeViewModel(networkProvider: NetworkService()))
    
    // MARK: - UI Components
    
    private let deletePostPopupView = DontBePopupView(popupTitle: StringLiterals.Home.deletePopupTitleLabel,
                                                      popupContent: StringLiterals.Home.deletePopupContentLabel,
                                                      leftButtonTitle: StringLiterals.Home.deletePopupLefteftButtonTitle,
                                                      rightButtonTitle: StringLiterals.Home.deletePopupRightButtonTitle)
        
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
    }
    
    init(viewModel: DeletePostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension DeletePopupViewController {
    private func setHierarchy() {
        view.addSubviews(deletePostPopupView)
    }
    
    private func setLayout() {
        deletePostPopupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        deletePostPopupView.delegate = self
    }
    
    @objc
    private func dismissViewController() {
        self.dismiss(animated: false)
    }
}

// MARK: - Network

extension DeletePopupViewController {
    private func getAPI() {
        let input = DeletePostViewModel.Input(deleteButtonDidTapped: deleteButtonTapped)
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.popView
            .receive(on: RunLoop.main)
            .sink { _ in
                self.dismiss(animated: true)
                // postVC pop
                NotificationCenter.default.post(name: DeletePopupViewController.popViewController, object: nil)
                NotificationCenter.default.post(name: DeletePopupViewController.reloadData, object: nil)
                self.homeVC.homeCollectionView.reloadData()
            }
            .store(in: self.cancelBag)
    }
}

extension DeletePopupViewController: DontBePopupDelegate {
    func cancleButtonTapped() {
        self.dismiss(animated: false)
    }
    
    func confirmButtonTapped() {
        self.homeVC.refreshCollectionViewDidDrag()
        NotificationCenter.default.post(name: DeletePopupViewController.showDeletePostToastNotification, object: nil, userInfo: ["showDeleteToast": true])
    }
}

