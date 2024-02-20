//
//  MyPageSignOutViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 2/12/24.
//

import UIKit

class MyPageSignOutViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let myView = MyPageSignOutView()
    private var navigationBackButton = BackButton()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = myView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
    }
}

// MARK: - Extensions

extension MyPageSignOutViewController {
    private func setUI() {
        self.title = StringLiterals.MyPage.MyPageSignOutNavigationTitle
        self.view.backgroundColor = .donWhite
        
        self.navigationController?.navigationBar.backgroundColor = .donWhite
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        self.navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem.backButton(target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setHierarchy() {
        
    }
    
    private func setLayout() {
        
    }
    
    private func setDelegate() {
        
    }
    
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
