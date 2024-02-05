//
//  CancelReplyPopupViewController.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/14/24.
//

import UIKit

final class CancelReplyPopupViewController: UIViewController {
    
    // MARK: - Properties
    static let popViewController = NSNotification.Name("pop")
    
    // MARK: - UI Components
    
    private let cancelPopupView = DontBePopupView(popupTitle: "",
                                                  popupContent: StringLiterals.Post.popupReplyContentLabel,
                                                  leftButtonTitle: StringLiterals.Post.popupReplyCancelButtonTitle,
                                                  rightButtonTitle: StringLiterals.Post.popupReplyConfirmButtonTitle)
    private let writeReplyVC = WriteReplyViewController(viewModel: WriteReplyViewModel(networkProvider: NetworkService()))
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setHierarchy()
        setLayout()
        setDelegate()
    }
}

// MARK: - Extensions

extension CancelReplyPopupViewController {

    private func setHierarchy() {
        view.addSubviews(cancelPopupView)
    }
    
    private func setLayout() {
        cancelPopupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        cancelPopupView.delegate = self
    }
}

extension CancelReplyPopupViewController: DontBePopupDelegate {
    func cancleButtonTapped() {
        self.dismiss(animated: false)
    }

    func confirmButtonTapped() {
        NotificationCenter.default.post(name: CancelReplyPopupViewController.popViewController, object: nil)
        self.dismiss(animated: false)
    }
}

