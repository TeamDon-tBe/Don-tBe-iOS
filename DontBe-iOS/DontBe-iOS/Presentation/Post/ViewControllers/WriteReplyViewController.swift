//
//  WriteReplyViewController.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/14/24.
//

import UIKit

final class WriteReplyViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let writeView = WriteReplyView()
    private lazy var cancelReplyPopupVC = CancelReplyPopupViewController()
    
    // MARK: - Life Cycles
    
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
        setAddTarget()
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
    
    private func setAddTarget() {
        writeView.writeReplyView.postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func postButtonTapped() {
        popupNavigation()
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
