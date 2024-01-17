//
//  TransparentPopupViewController.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/14/24.
//

import UIKit

final class TransparentPopupViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    let transparentButtonPopupView = DontBePopupView(popupImage: ImageLiterals.Popup.transparentButtonImage,
                                                             popupTitle: StringLiterals.Home.transparentPopupTitleLabel,
                                                             popupContent: StringLiterals.Home.transparentPopupContentLabel,
                                                             leftButtonTitle: StringLiterals.Home.transparentPopupLefteftButtonTitle,
                                                             rightButtonTitle: StringLiterals.Home.transparentPopupRightButtonTitle)
    
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

extension TransparentPopupViewController {
    private func setUI() {
        
    }
    
    private func setHierarchy() {
        view.addSubviews(transparentButtonPopupView)
    }
    
    private func setLayout() {
        transparentButtonPopupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        
    }
}

// MARK: - Network

extension TransparentPopupViewController {
    private func getAPI() {
        
    }
}
