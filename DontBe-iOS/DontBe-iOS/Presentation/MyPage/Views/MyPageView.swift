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
    
    static var pushCount: Int = 0
    private let dummy = TransparencyInfoDummy.dummy()
    
    var transparencyInfoView: DontBeTransparencyInfoView?
    
    // MARK: - UI Components
    
    var myPageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .donBlack
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private var myPageContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var myPageProfileView = MyPageProfileView()
    
    private var myPageSegmentedView: UIView = {
        let view = UIView()
        view.backgroundColor = .donWhite
        return view
    }()
    
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
    
    var myPageBottomsheet = DontBeBottomSheetView(profileEditImage: ImageLiterals.MyPage.btnEditProfile,
                                                  accountInfoImage: ImageLiterals.MyPage.btnAccount,
                                                  feedbackImage: ImageLiterals.MyPage.btnFeedback,
                                                  customerCenterImage: ImageLiterals.MyPage.btnCustomerCenter)
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        setAddTarget()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension MyPageView {
    private func setUI() {
        self.backgroundColor = .donWhite
    }
    
    private func setHierarchy() {
        self.addSubviews(myPageScrollView)
        myPageScrollView.addSubview(myPageContentView)
        myPageContentView.addSubviews(myPageProfileView,
                                      myPageSegmentedView)
        myPageSegmentedView.addSubviews(segmentedControl,
                                        pageViewController.view)
    }
    
    private func setLayout() {
        myPageScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        myPageContentView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(myPageScrollView.snp.width)
            $0.height.equalTo(2000)
        }
        
        myPageProfileView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(270.adjusted)
        }
        
        myPageSegmentedView.snp.makeConstraints {
            $0.top.equalTo(myPageProfileView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(54.adjusted)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(2.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2000)
        }
    }
    
    private func setDelegate() {
        
    }
    
    private func setAddTarget() {
        self.myPageProfileView.transparencyInfoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func infoButtonTapped() {
        self.myPageScrollView.isScrollEnabled = false
        
        transparencyInfoView = DontBeTransparencyInfoView()
        self.addSubview(transparencyInfoView!)
        
        transparencyInfoView?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        transparencyInfoView?.bringSubviewToFront(self)
        transparencyInfoView?.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        transparencyInfoView?.infoScrollView.delegate = self
    }
    
    @objc
    private func closeButtonTapped() {        
        self.transparencyInfoView?.removeFromSuperview()
    }
    
    private func setTransparencyInfoView(view: DontBeCustomInfoView) {
        view.InfoImage.image = self.dummy[MyPageView.pushCount].infoImage
        view.title.text = self.dummy[MyPageView.pushCount].title
        view.content.text = self.dummy[MyPageView.pushCount].content
    }
}

extension MyPageView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        var currentPage = Int((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        
        if ((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) < 0 {
            currentPage = 0
        }
        
        switch currentPage {
        case 0:
            transparencyInfoView?.progressImage.image = ImageLiterals.TransparencyInfo.progressbar1
        case 1:
            transparencyInfoView?.progressImage.image = ImageLiterals.TransparencyInfo.progressbar2
        case 2:
            transparencyInfoView?.progressImage.image = ImageLiterals.TransparencyInfo.progressbar3
        case 3:
            transparencyInfoView?.progressImage.image = ImageLiterals.TransparencyInfo.progressbar4
        case 4:
            transparencyInfoView?.progressImage.image = ImageLiterals.TransparencyInfo.progressbar5
        default:
            break
        }
        
        let allowedRange = 0..<5
        if !allowedRange.contains(currentPage) {
            let targetOffsetX = CGFloat(min(max(allowedRange.lowerBound, currentPage), allowedRange.upperBound - 1)) * scrollView.frame.size.width
            scrollView.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: true)
        }
    }
}
