//
//  TabBarController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/7/24.
//

import UIKit

final class DontBeTabBarController: UITabBarController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.setTabBarController()
        self.setInitialFont()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
    }
    
    // MARK: - TabBar Height
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeAreaHeight = view.safeAreaInsets.bottom
        let tabBarHeight: CGFloat = 60.0
        tabBar.frame.size.height = tabBarHeight + safeAreaHeight
        tabBar.frame.origin.y = view.frame.height - tabBarHeight - safeAreaHeight
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        self.tabBar.backgroundColor = UIColor.donWhite // 탭바 배경색 설정
        self.tabBar.isTranslucent = false // 배경이 투명하지 않도록 설정
    }
    
    // MARK: - Methods
    
    private func setTabBarController() {
        var tabNavigationControllers = [UINavigationController]()
        
        for item in DontBeTabBarItem.allCases {
            let tabNavController = createTabNavigationController(
                title: item.title,
                image: item.icon,
                selectedImage: item.selectedIcon,
                viewController: item.targetViewController
            )
            tabNavigationControllers.append(tabNavController)
        }
        
        setViewControllers(tabNavigationControllers, animated: true)
    }
    
    private func createTabNavigationController(title: String, image: UIImage, selectedImage: UIImage, viewController: UIViewController?) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        
        let taBbarItem = UITabBarItem(
            title: title,
            image: image.withRenderingMode(.alwaysOriginal),
            selectedImage: selectedImage.withRenderingMode(.alwaysOriginal)
        )
        
        // image를 위로 올리기 위한 UIEdgeInsets 설정
        taBbarItem.imageInsets = UIEdgeInsets(top: -3, left: 0, bottom: 0, right: 0)
        
        // title을 이미지 위로 올리기 위한 UIEdgeInsets 설정
        taBbarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.font(.caption4),
            .foregroundColor: UIColor.donGray7
        ]
        UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
        
        tabNavigationController.tabBarItem = taBbarItem
        
        if let viewController = viewController {
            tabNavigationController.viewControllers = [viewController]
        }
        
        return tabNavigationController
    }
    
    private func setInitialFont() {
        // 디폴트로 선택된 탭의 폰트 설정
        if let selectedItem = self.tabBar.items?[self.selectedIndex] {
            self.applyFontAttributes(to: selectedItem, isSelected: true)
        }
    }
    
    private func applyFontAttributes(to tabBarItem: UITabBarItem, isSelected: Bool) {
        let attributes: [NSAttributedString.Key: Any]
        
        if isSelected {
            attributes = [
                .font: UIFont.font(.caption3),
                .foregroundColor: UIColor.donSecondary
            ] // title이 선택되었을 때 폰트, 색상 설정
        } else {
            attributes = [
                .font: UIFont.font(.caption4),
                .foregroundColor: UIColor.donGray7
            ] // title이 선택되지 않았을 때 폰트, 색상 설정
        }
        tabBarItem.setTitleTextAttributes(attributes, for: .normal)
    }
}

extension DontBeTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if let selectedViewController = tabBarController.selectedViewController {
            applyFontAttributes(to: selectedViewController.tabBarItem, isSelected: true)
        }
        
        let viewController = tabBarController.viewControllers ?? [UIViewController()]
        
        for (index, controller) in viewController.enumerated() {
            if let tabBarItem = controller.tabBarItem {
                if index != tabBarController.selectedIndex {
                    applyFontAttributes(to: tabBarItem, isSelected: false)
                }
            }
        }
    }
}
