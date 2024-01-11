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
            rootView.pageViewController.setViewControllers(
                [rootView.dataViewControllers[self.currentPage]],
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
                                           action: nil)
        
        navigationItem.rightBarButtonItem = hambergerButton
    }
    
    private func setDelegate() {
        rootView.pageViewController.delegate = self
        rootView.pageViewController.dataSource = self
    }
    
    private func setAddTarget() {
        rootView.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
    }
    
    @objc private func changeValue(control: UISegmentedControl) {
        // 코드로 값을 변경하면 해당 메소드 호출 x
        self.currentPage = control.selectedSegmentIndex
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
