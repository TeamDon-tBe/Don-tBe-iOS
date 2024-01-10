//
//  WriteViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/8/24.
//

import UIKit

final class WriteViewController: UIViewController {
    
    // MARK: - Properties
    
    static let showUploadToastNotification = Notification.Name("ShowUploadToastNotification")
    
    // MARK: - UI Components
    
    private let rootView = WriteView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAPI()
        setUI()
        setDelegate()
        setAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = false
    }
}

// MARK: - Extensions

extension WriteViewController {
    func setUI() {
        self.view.backgroundColor = .donWhite
        self.title = StringLiterals.Write.writeNavigationTitle
        self.navigationController?.navigationBar.tintColor = .donPrimary
        
        let backButton = UIBarButtonItem(
            title: StringLiterals.Write.writeNavigationBarButtonItemTitle,
            style: .plain,
            target: self,
            action: #selector(cancleNavigationBarButtonTapped)
        )
        
        // 커스텀 백 버튼의 속성 설정 - 색상, 폰트
        backButton.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.donGray11,
            NSAttributedString.Key.font: UIFont.font(.body4)
        ], for: .normal)

        navigationItem.leftBarButtonItem = backButton
    }
    
    func setDelegate() {
        self.rootView.writeCanclePopupView.delegate = self
    }
    
    func setAddTarget() {
        self.rootView.writeTextView.postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
    }
    
    func sendData() {
        NotificationCenter.default.post(name: WriteViewController.showUploadToastNotification, object: nil, userInfo: ["showToast": true])
    }
    
    @objc
    func cancleNavigationBarButtonTapped() {
        // 텍스트가 비어있는 경우 POP
        if self.rootView.writeTextView.contentTextView.text == "" {
            popupNavigation()
        } else {
            self.rootView.writeCanclePopupView.alpha = 1
        }
    }
    
    @objc
    func postButtonTapped() {
        popupNavigation()
        sendData()
    }
    
    @objc
    private func popupNavigation() {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.selectedIndex = 0
    }
}

// MARK: - Network

extension WriteViewController {
    func getAPI() {
        
    }
}

extension WriteViewController: DontBePopupDelegate {
    func cancleButtonTapped() {
        self.rootView.writeCanclePopupView.alpha = 0
    }
    
    func confirmButtonTapped() {
        self.rootView.writeCanclePopupView.alpha = 0
        popupNavigation()
    }
}
