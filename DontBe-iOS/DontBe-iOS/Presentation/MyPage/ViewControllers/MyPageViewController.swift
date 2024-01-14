//
//  MyPageViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/11/24.
//

import UIKit

import SnapKit

final class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            rootView.pageViewController.setViewControllers(
                [rootView.dataViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
            rootView.myPageScrollView.setContentOffset(CGPoint(x: 0, y: -rootView.myPageScrollView.contentInset.top - navigationBarHeight - statusBarHeight), animated: true)
            rootView.myPageContentViewController.homeCollectionView.isScrollEnabled = true
            rootView.myPageScrollView.isScrollEnabled = true
        }
    }
    
    var tabBarHeight: CGFloat = 0
    
    // MARK: - UI Components
    
    let rootView = MyPageView()
    
    let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAPI()
        setUI()
        setLayout()
        setDelegate()
        setAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.title = StringLiterals.MyPage.MyPageNavigationTitle
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donWhite]
//        self.navigationController?.navigationBar.backgroundColor = .donBlack
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.navigationBar.backgroundColor = .clear
        statusBarView.removeFromSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeAreaHeight = view.safeAreaInsets.bottom
        let tabBarHeight: CGFloat = 70.0.adjusted
        
        self.tabBarHeight = tabBarHeight + safeAreaHeight
        
        rootView.pageViewController.view.snp.remakeConstraints {
            $0.top.equalTo(rootView.segmentedControl.snp.bottom).offset(2.adjusted)
            $0.leading.trailing.equalToSuperview()
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
            $0.height.equalTo(UIScreen.main.bounds.height - statusBarHeight - navigationBarHeight - self.tabBarHeight)
        }
    }
}

// MARK: - Extensions

extension MyPageViewController {
    private func setUI() {
        self.view.backgroundColor = .donBlack
        self.tabBarController?.tabBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .donBlack
        
        let image = ImageLiterals.MyPage.icnMenu
        let renderedImage = image.withRenderingMode(.alwaysOriginal)
        let hambergerButton = UIBarButtonItem(image: renderedImage,
                                              style: .plain,
                                              target: self,
                                              action: #selector(hambergerButtonTapped))
        
        navigationItem.rightBarButtonItem = hambergerButton
    }
    
    private func setLayout() {
        rootView.pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(rootView.segmentedControl.snp.bottom).offset(2.adjusted)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        rootView.myPageScrollView.delegate = self
        rootView.pageViewController.delegate = self
        rootView.pageViewController.dataSource = self
    }
    
    private func setAddTarget() {
        rootView.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
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
    
    private func moveTop() {
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        rootView.myPageScrollView.setContentOffset(CGPoint(x: 0, y: -rootView.myPageScrollView.contentInset.top - navigationBarHeight - statusBarHeight), animated: true)
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
            let index = rootView.dataViewControllers.firstIndex(of: viewController),
            index - 1 >= 0
        else { return nil }
        return rootView.dataViewControllers[index - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = rootView.dataViewControllers.firstIndex(of: viewController),
            index + 1 < rootView.dataViewControllers.count
        else { return nil }
        return rootView.dataViewControllers[index + 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            let viewController = pageViewController.viewControllers?[0],
            let index = rootView.dataViewControllers.firstIndex(of: viewController)
        else { return }
        self.currentPage = index
        rootView.segmentedControl.selectedSegmentIndex = index
    }
}

extension MyPageViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var yOffset = scrollView.contentOffset.y
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        
        scrollView.isScrollEnabled = true
        rootView.myPageContentViewController.homeCollectionView.isScrollEnabled = false
        rootView.myPageContentViewController.homeCollectionView.isUserInteractionEnabled = false
        
        if yOffset <= -(navigationBarHeight + statusBarHeight) {
            rootView.myPageContentViewController.homeCollectionView.isScrollEnabled = false
            rootView.myPageContentViewController.homeCollectionView.isUserInteractionEnabled = false
            
            yOffset = -(navigationBarHeight + statusBarHeight)
            rootView.segmentedControl.frame.origin.y = yOffset + statusBarHeight + navigationBarHeight
            rootView.segmentedControl.snp.remakeConstraints {
                $0.top.equalTo(rootView.myPageProfileView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(54.adjusted)
            }
            
            rootView.pageViewController.view.snp.remakeConstraints {
                $0.top.equalTo(rootView.segmentedControl.snp.bottom).offset(2.adjusted)
                $0.leading.trailing.equalToSuperview()
                let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
                $0.height.equalTo(UIScreen.main.bounds.height - statusBarHeight - navigationBarHeight - self.tabBarHeight)
            }
        } else if yOffset >= (rootView.myPageProfileView.frame.height - statusBarHeight - navigationBarHeight) {
            rootView.segmentedControl.frame.origin.y = yOffset - rootView.myPageProfileView.frame.height + statusBarHeight + navigationBarHeight
            rootView.segmentedControl.snp.remakeConstraints {
                $0.top.equalTo(rootView.myPageProfileView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(54.adjusted)
            }
            
            rootView.pageViewController.view.frame.origin.y = yOffset - rootView.myPageProfileView.frame.height + statusBarHeight + navigationBarHeight + rootView.segmentedControl.frame.height
            
            rootView.pageViewController.view.snp.remakeConstraints {
                $0.top.equalTo(rootView.segmentedControl.snp.bottom).offset(2.adjusted)
                $0.leading.trailing.equalToSuperview()
                let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
                $0.height.equalTo(UIScreen.main.bounds.height - statusBarHeight - navigationBarHeight - self.tabBarHeight)
            }
            
            scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
            
            rootView.myPageContentViewController.homeCollectionView.isScrollEnabled = true
            rootView.myPageContentViewController.homeCollectionView.isUserInteractionEnabled = true
        }
    }
}
