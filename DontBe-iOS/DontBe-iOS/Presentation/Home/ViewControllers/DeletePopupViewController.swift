//
//  DeletePopupViewController.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/15/24.
//

import UIKit

final class DeletePopupViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let deletePostPopupView = DontBePopupView(popupTitle: StringLiterals.Home.deletePopupTitleLabel,
                                                      popupContent: StringLiterals.Home.deletePopupContentLabel,
                                                      leftButtonTitle: StringLiterals.Home.deletePopupLefteftButtonTitle,
                                                      rightButtonTitle: StringLiterals.Home.deletePopupRightButtonTitle)
    
    private let myView = PostPopupView()
    
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

extension DeletePopupViewController {
    private func setUI() {
        
    }
    
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
}

// MARK: - Network

extension DeletePopupViewController {
    private func getAPI() {
        
    }
}

extension DeletePopupViewController: DontBePopupDelegate {
    func cancleButtonTapped() {
        self.dismiss(animated: false)
    }
    
    func confirmButtonTapped() {
        self.dismiss(animated: false)
        // ✅ 투명도 주기 버튼 클릭 시 액션 추가
    }
}

