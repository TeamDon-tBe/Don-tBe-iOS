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
    
    static var pushCount: Int = 0
    private let dummy = TransparencyInfoDummy.dummy()
    
    var transparencyInfoView: DontBeTransparencyInfoView?
    
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
    var myPageSegmentedControlView = MyPageSegmentedControlView()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
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
                                      myPageSegmentedControlView)
    }
    
    private func setLayout() {
        myPageScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        myPageContentView.snp.makeConstraints {
            $0.edges.equalTo(myPageScrollView)
            $0.width.equalTo(myPageScrollView.snp.width)
            $0.height.equalTo(1000)
        }
        
        myPageProfileView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(myPageSegmentedControlView.snp.top)
        }
        
        myPageSegmentedControlView.snp.makeConstraints {
            $0.top.equalTo(myPageProfileView.transparencyInfoButton.snp.bottom).offset(25.adjusted)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setAddTarget() {
        self.myPageProfileView.transparencyInfoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func infoButtonTapped() {
        self.myPageScrollView.isScrollEnabled = false
        
        transparencyInfoView = DontBeTransparencyInfoView()
        myPageContentView.addSubview(transparencyInfoView!)
        
        transparencyInfoView?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        transparencyInfoView?.bringSubviewToFront(myPageContentView)
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
