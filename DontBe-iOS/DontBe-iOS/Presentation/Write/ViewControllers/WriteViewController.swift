//
//  WriteViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/8/24.
//

import UIKit

final class WriteViewController: UIViewController {
    
    // MARK: - Properties
    
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
        
        let backButton = UIBarButtonItem(
            title: StringLiterals.Write.writeNavigationBarButtonItemTitle,
            style: .plain,
            target: self,
            action: #selector(cancleButtonTapped)
        )
        
        // 커스텀 백 버튼의 속성 설정 - 색상, 폰트
        backButton.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.donGray11,
            NSAttributedString.Key.font: UIFont.font(.body4)
        ], for: .normal)

        navigationItem.leftBarButtonItem = backButton
    }
    
    }
    
    func setAddTarget() {
        self.rootView.writeTextView.postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
    }
    
    }
}

// MARK: - Network

extension WriteViewController {
    func getAPI() {
        
    }
}
