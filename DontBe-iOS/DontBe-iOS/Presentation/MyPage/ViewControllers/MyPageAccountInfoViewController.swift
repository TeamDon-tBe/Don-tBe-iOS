//
//  MyPageAccountInfoViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/12/24.
//

import UIKit

class MyPageAccountInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
        self.view.backgroundColor = .donError
        self.title = StringLiterals.MyPage.MyPageAccountInfoNavigationTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        
        let backButton = UIBarButtonItem.backButton(target: self, action: #selector(backButtonPressed))
        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc
    private func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
