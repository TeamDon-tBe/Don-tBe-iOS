//
//  MyPageViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/11/24.
//

import UIKit

final class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let rootView = MyPageView()
    
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
}

// MARK: - Extensions

extension MyPageViewController {
    private func setUI() {
        
    }
    
    private func setDelegate() {
        
    }
    
    private func setAddTarget() {
        
    }
}

// MARK: - Network

extension MyPageViewController {
    private func getAPI() {
        
    }
}
