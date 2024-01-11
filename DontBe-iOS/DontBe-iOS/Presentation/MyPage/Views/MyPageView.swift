//
//  MyPageView.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/11/24.
//

import UIKit

import SnapKit

final class MyPageView: UIView {

    // MARK: - Properties
    
    var dataViewControllers: [UIViewController] {
        [self.myPageContentViewController, self.myPageCommentViewController]
      }
    
    // MARK: - UI Components
    
    private var myPageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .donBlack
        return scrollView
    }()
    
    private var myPageContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var myPageProfileView = MyPageProfileView()
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = MyPageSegmentedControl(items: ["게시글", "답글"])
        segmentedControl.backgroundColor = .donWhite
        segmentedControl.layer.cornerRadius = 0
        segmentedControl.layer.masksToBounds = true
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.donGray12], for: .normal)
        segmentedControl.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.donPrimary,
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
        setAddTarget()
        setRegisterCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension MyPageView {
    private func setUI() {
        self.backgroundColor = .donBlack
    }
    
    private func setHierarchy() {
        self.addSubviews(myPageScrollView)
        myPageScrollView.addSubview(myPageContentView)
        myPageContentView.addSubviews(myPageProfileView, 
                                      segmentedControl,
                                      pageViewController.view)
    }
    
    private func setLayout() {
        myPageScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        myPageContentView.snp.makeConstraints {
            $0.edges.equalTo(myPageScrollView)
            $0.width.equalTo(myPageScrollView.snp.width)
        }
        
        myPageProfileView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(300.adjusted)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(myPageProfileView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(54.adjusted)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1000.adjusted) // 임의 값 설정
        }
    }
    
    private func setAddTarget() {

    }
    
    private func setRegisterCell() {
        
    }
    
    private func setDataBind() {
        
    }
}
