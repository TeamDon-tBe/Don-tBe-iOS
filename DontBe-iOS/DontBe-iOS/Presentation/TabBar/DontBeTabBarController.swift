//
//  TabBarController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/7/24.
//

import UIKit

final class DontBeTabBarController: UITabBarController {
    
    private let networkProvider = NetworkService()
    
    var beforeIndex: Int = 0
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.setTabBarController()
        self.setInitialFont()
        self.setTabBarBadge()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        self.delegate = self
    }
    
    // MARK: - TabBar Height
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeAreaHeight = view.safeAreaInsets.bottom
        let tabBarHeight: CGFloat = 70.0
        tabBar.frame.size.height = tabBarHeight + safeAreaHeight
        tabBar.frame.origin.y = view.frame.height - tabBarHeight - safeAreaHeight
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        self.tabBar.backgroundColor = UIColor.donWhite // 탭바 배경색 설정
        self.tabBar.isTranslucent = false // 배경이 투명하지 않도록 설정
        self.tabBar.clipsToBounds = true // 탭바 위쪽에 선 생기는 거 없앰
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
        
        setViewControllers(tabNavigationControllers, animated: false)
    }
    
    private func createTabNavigationController(title: String, image: UIImage, selectedImage: UIImage, viewController: UIViewController?) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        
        let tabBarItem = UITabBarItem(
            title: title,
            image: image.withRenderingMode(.alwaysOriginal),
            selectedImage: selectedImage.withRenderingMode(.alwaysOriginal)
        )
        
        // image를 위로 올리기 위한 UIEdgeInsets 설정
        tabBarItem.imageInsets = UIEdgeInsets(top: -7, left: 0, bottom: 0, right: 0)
        
        // title을 위로 올리기 위한 UIEdgeInsets 설정
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -13)
        
        applyFontColorAttributes(to: UITabBarItem.appearance(), isSelected: false)
        
        tabNavigationController.tabBarItem = tabBarItem
        
        if let viewController = viewController {
            tabNavigationController.viewControllers = [viewController]
        }
        
        return tabNavigationController
    }
    
    private func setInitialFont() {
        // 디폴트로 선택된 탭의 폰트 설정
        if let selectedItem = self.tabBar.items?[self.selectedIndex] {
            self.applyFontColorAttributes(to: selectedItem, isSelected: true)
        }
    }
    
    func applyFontColorAttributes(to tabBarItem: UITabBarItem, isSelected: Bool) {
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
    
    private func setTabBarBadge() {
        Task {
            let data = try await getNotificationCheckAPI()
            if data?.data?.notificationNumber ?? 0 > 0 {
                self.tabBar.items?[2].image = ImageLiterals.TabBar.icnNotificationUnread
            } else {
                self.tabBar.items?[2].image = ImageLiterals.TabBar.icnNotificationRead
            }
        }
    }
    
    private func getNotificationCheckAPI() async throws -> BaseResponse<NotificationNotCheckResponseDTO>? {
        do {
            guard let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") else { return nil }
            let data: BaseResponse<NotificationNotCheckResponseDTO>? = try await self.networkProvider.donNetwork(
                type: .get,
                baseURL: Config.baseURL + "/notification/number",
                accessToken: accessToken,
                body: EmptyBody(),
                pathVariables: ["": ""])
            return data
        } catch {
            return nil
        }
    }
}

extension DontBeTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if selectedIndex == 1 {
            self.selectedIndex = 0
        }
        
        if selectedIndex == 2 {
            self.tabBar.items?[2].image = ImageLiterals.TabBar.icnNotificationRead
        }
        
        if let selectedViewController = tabBarController.selectedViewController {
            applyFontColorAttributes(to: selectedViewController.tabBarItem, isSelected: true)
        }
        let myViewController = tabBarController.viewControllers ?? [UIViewController()]
        for (index, controller) in myViewController.enumerated() {
            if let tabBarItem = controller.tabBarItem {
                if index != tabBarController.selectedIndex {
                    applyFontColorAttributes(to: tabBarItem, isSelected: false)
                }
            }
        }
        beforeIndex = self.selectedIndex
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 1 {
            let destinationViewController = WriteViewController(viewModel: WriteViewModel(networkProvider: NetworkService()))
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        }
        
        guard let selectedViewController = tabBarController.selectedViewController else {
            return true
        }
        
        // 탭바 인덱스 선택 후 탭바 클릭시 최상단으로 가도록 구현
        if selectedViewController == viewController {
            if tabBarController.selectedIndex == 0 {
                if let navigationController = viewController as? UINavigationController {
                    if let topViewController = navigationController.topViewController as? HomeViewController {
                        topViewController.homeCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    }
                }
            } else if tabBarController.selectedIndex == 2 {
                if let navigationController = viewController as? UINavigationController {
                    if let topViewController = navigationController.topViewController as? NotificationViewController {
                        topViewController.notificationTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    }
                }
            }
        }
        return true
    }
}
