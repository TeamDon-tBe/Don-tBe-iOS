//
//  MyPageSegmentedControlView.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/11/24.
//

import UIKit

import SnapKit

final class MyPageSegmentedControlView: UIView {

    // MARK: - Properties
    
    var dataViewControllers: [UIViewController] {
        [self.myPageContentViewController, self.myPageCommentViewController]
    }
    
    // MARK: - UI Components
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = MyPageSegmentedControl(items: ["게시글", "답글"])
        segmentedControl.backgroundColor = .donWhite
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.donGray7,
                .font: UIFont.font(.body1)
            ], for: .normal
        )
        segmentedControl.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.donGray12,
                .font: UIFont.font(.body1)
            ],
            for: .selected
        )
        return segmentedControl
    }()
    
    lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        return vc
    }()
    
    let myPageContentViewController = MyPageContentViewController()
    let myPageCommentViewController = MyPageCommentViewController()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension MyPageSegmentedControlView {
    private func setUI() {
        self.backgroundColor = .donWhite
        pageViewController.view.backgroundColor = .donWhite
    }
    
    private func setHierarchy() {
        self.addSubviews(segmentedControl,
                         pageViewController.view)
    }
    
    private func setLayout() {
        segmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(54.adjusted)
        }

        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
