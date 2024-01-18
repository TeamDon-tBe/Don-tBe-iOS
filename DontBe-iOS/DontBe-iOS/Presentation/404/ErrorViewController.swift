//
//  ErrorViewController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/18/24.
//

import UIKit

import SnapKit

final class ErrorViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let errorImage: UIImageView = {
        let emptyImage = UIImageView()
        emptyImage.image = ImageLiterals.Common.img404
        return emptyImage
    }()
    
    private let errorTitle: UILabel = {
        let emptyTitle = UILabel()
        emptyTitle.text = StringLiterals.Network.errorMessage
        emptyTitle.textColor = .donBlack
        emptyTitle.font = .font(.body1)
        emptyTitle.setTextWithLineHeight(text: emptyTitle.text, lineHeight: 22.adjusted, alignment: .center)
        emptyTitle.numberOfLines = 2
        return emptyTitle
    }()
    
    private let homeButton = CustomButton(title: StringLiterals.Button.goHome, backColor: .donBlack, titleColor: .donWhite)
    
    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
    }
}


// MARK: - Extensions

extension ErrorViewController {
    private func setUI() {
        self.view.backgroundColor = .donWhite
    }
    
    private func setHierarchy() {
        self.view.addSubviews(errorImage,
                              errorTitle,
                              homeButton)
    }
    
    private func setLayout() {
        errorImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(statusBarHeight + 182.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(255.adjusted)
            $0.height.equalTo(150.adjusted)
        }
        
        errorTitle.snp.makeConstraints {
            $0.top.equalTo(errorImage.snp.bottom).offset(34.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        homeButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(29.adjusted)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setAddTarget() {
        self.homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func homeButtonTapped() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            DispatchQueue.main.async {
                let viewController = DontBeTabBarController()
                viewController.selectedIndex = 0
                if let selectedViewController = viewController.selectedViewController {
                    viewController.applyFontColorAttributes(to: selectedViewController.tabBarItem, isSelected: true)
                }
                sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: viewController)
            }
        }
    }
}
