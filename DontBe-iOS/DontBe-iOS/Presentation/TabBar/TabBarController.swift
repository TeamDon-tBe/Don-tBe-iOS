//
//  TabBarController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/7/24.
//

import UIKit

final class TabbarController: UITabBarController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.addTabBarController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        // 탭바 배경색 설정
        self.tabBar.backgroundColor = UIColor.white  // 적절한 색상으로 변경
        self.tabBar.isTranslucent = false // 배경이 투명하지 않도록 설정
    }
    
    // MARK: - Methods
    
    private func addTabBarController() {
        var tabNavigationControllers = [UINavigationController]()
        
        for item in TabbarItem.allCases {
            let tabNavController = createTabNavigationController(
                title: item.description,
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
        
        let tabbarItem = UITabBarItem(
            title: title,
            image: image.withRenderingMode(.alwaysOriginal),
            selectedImage: selectedImage.withRenderingMode(.alwaysOriginal)
        )
        
        // title이 선택되지 않았을 때 폰트, 색상 설정
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.font(.caption3),
            .foregroundColor: UIColor.donGray7
        ]
        
        // title이 선택되었을 때 폰트, 색상 설정
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.font(.caption4),
            .foregroundColor: UIColor.donSecondary
        ]
        
        tabbarItem.setTitleTextAttributes(normalAttributes, for: .normal)
        tabbarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        tabNavigationController.tabBarItem = tabbarItem
        
        if let viewController = viewController {
            tabNavigationController.viewControllers = [viewController]
        }
        return tabNavigationController
    }
}

