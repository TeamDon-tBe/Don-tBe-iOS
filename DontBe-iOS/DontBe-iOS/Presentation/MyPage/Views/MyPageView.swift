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

    }
    
    private func setRegisterCell() {
        
    }
    
    private func setDataBind() {
        
    }
}
