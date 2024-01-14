//
//  CancelReplyPopupViewController.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/14/24.
//

import UIKit

final class CancelReplyPopupViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let cancelPopupView = DontBePopupView(popupTitle: "",
                                                  popupContent: StringLiterals.Post.popupReplyContentLabel,
                                                  leftButtonTitle: StringLiterals.Post.popupReplyCancelButtonTitle,
                                                  rightButtonTitle: StringLiterals.Post.popupReplyConfirmButtonTitle)
    
    private let myView = PostPopupView()
    private let writeReplyVC = WriteReplyViewController()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = myView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAPI()
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
    }
}

// MARK: - Extensions

extension CancelReplyPopupViewController {
    private func setUI() {
        
    }
    
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

// MARK: - Network

extension CancelReplyPopupViewController {
    private func getAPI() {
        
    }
}

extension CancelReplyPopupViewController: DontBePopupDelegate {
    func cancleButtonTapped() {
        self.dismiss(animated: false)
    }

    func confirmButtonTapped() {
        self.dismiss(animated: false)
    }
}

