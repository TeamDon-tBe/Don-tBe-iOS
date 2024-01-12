//
//  MyPageViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/11/24.
//

import UIKit

final class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            rootView.myPageSegmentedControlView.pageViewController.setViewControllers(
                [rootView.myPageSegmentedControlView.dataViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Extensions

extension MyPageViewController {
    private func setUI() {
        self.title = StringLiterals.MyPage.MyPageNavigationTitle
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donWhite]
        
        let image = ImageLiterals.MyPage.icnMenu
        let renderedImage = image.withRenderingMode(.alwaysOriginal)
        let hambergerButton = UIBarButtonItem(image: renderedImage,
                                              style: .plain,
                                              target: self,
                                              action: #selector(hambergerButtonTapped))
        
        navigationItem.rightBarButtonItem = hambergerButton
    }
    
    private func setDelegate() {
        rootView.myPageSegmentedControlView.pageViewController.delegate = self
        rootView.myPageSegmentedControlView.pageViewController.dataSource = self
    }
    
    private func setAddTarget() {
        rootView.myPageSegmentedControlView.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        rootView.myPageBottomsheet.profileEditButton.addTarget(self, action: #selector(profileEditButtonTapped), for: .touchUpInside)
        rootView.myPageBottomsheet.accountInfoButton.addTarget(self, action: #selector(accountInfoButtonTapped), for: .touchUpInside)
        rootView.myPageBottomsheet.feedbackButton.addTarget(self, action: #selector(feedbackButtonTapped), for: .touchUpInside)
        rootView.myPageBottomsheet.customerCenterButton.addTarget(self, action: #selector(customerCenterButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }
    
    @objc
    private func hambergerButtonTapped() {
        rootView.myPageBottomsheet.showSettings()
    }
    
    @objc
    private func profileEditButtonTapped() {
        rootView.myPageBottomsheet.handleDismiss()
        let vc = MyPageEditProfileViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func accountInfoButtonTapped() {
        rootView.myPageBottomsheet.handleDismiss()
        let vc = MyPageAccountInfoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func feedbackButtonTapped() {
        
    }
    
    @objc
    private func customerCenterButtonTapped() {
        
    }
}

// MARK: - Network

extension MyPageViewController {
    private func getAPI() {
        
    }
}

extension MyPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = rootView.myPageSegmentedControlView.dataViewControllers.firstIndex(of: viewController),
            index - 1 >= 0
        else { return nil }
        return rootView.myPageSegmentedControlView.dataViewControllers[index - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = rootView.myPageSegmentedControlView.dataViewControllers.firstIndex(of: viewController),
            index + 1 < rootView.myPageSegmentedControlView.dataViewControllers.count
        else { return nil }
        return rootView.myPageSegmentedControlView.dataViewControllers[index + 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            let viewController = pageViewController.viewControllers?[0],
            let index = rootView.myPageSegmentedControlView.dataViewControllers.firstIndex(of: viewController)
        else { return }
        self.currentPage = index
        rootView.myPageSegmentedControlView.segmentedControl.selectedSegmentIndex = index
    }
}
