//
//  PostViewController.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/12/24.
//

import UIKit

final class PostViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let myView = ExampleView()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationItem.hidesBackButton = true
         self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
          
         let backButton = UIBarButtonItem.backButton(target: self, action: #selector(backButtonPressed))
         self.navigationItem.leftBarButtonItem = backButton
     }
}

// MARK: - Extensions

extension PostViewController {
    private func setUI() {
        self.navigationItem.title = StringLiterals.Post.navigationTitleLabel
        view.backgroundColor = .brown
    }
    
    private func setHierarchy() {
        
    }
    
    private func setLayout() {
        
    }
    
    private func setDelegate() {
        
    }
    
    @objc
    private func backButtonPressed() {
        
    }
}

// MARK: - Network

extension PostViewController {
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
