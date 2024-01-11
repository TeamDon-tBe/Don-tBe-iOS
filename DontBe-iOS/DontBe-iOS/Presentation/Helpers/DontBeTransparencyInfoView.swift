//
//  DontBeTransparencyInfoView.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/11/24.
//

import UIKit

import SnapKit

final class DontBeTransparencyInfoView: UIView {

    // MARK: - Properties
    
    static var pushCount: Int = 0
    private let dummy = TransparencyInfoDummy.dummy()
    
    // MARK: - UI Components
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .donWhite
        view.layer.cornerRadius = 10.adjusted
        return view
    }()
    
    let progressImage: UIImageView = {
        let progress = UIImageView()
        progress.image = ImageLiterals.TransparencyInfo.progressbar1
        progress.contentMode = .scaleAspectFit
        return progress
    }()
    
    let infoScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceVertical = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let infoContentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.TransparencyInfo.btnClose, for: .normal)
        return button
    }()
    
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

extension DontBeTransparencyInfoView {
    private func setUI() {
        self.backgroundColor = .donBlack.withAlphaComponent(0.6)
    }
    
    private func setHierarchy() {
        self.addSubview(container)
        container.addSubviews(progressImage,
                              closeButton,
                              infoScrollView)
        infoScrollView.addSubview(infoContentView)
    }
    
    private func setLayout() {
        container.snp.makeConstraints {
            $0.top.equalToSuperview().inset(67.adjusted)
            $0.leading.trailing.equalToSuperview().inset(18.adjusted)
            $0.height.equalTo(392.adjusted)
        }
        
        progressImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(40.adjusted)
            $0.height.equalTo(6.adjusted)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(18.adjusted)
            $0.size.equalTo(44.adjusted)
        }
        
        infoScrollView.snp.makeConstraints {
            $0.top.equalTo(progressImage.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        infoContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(infoScrollView)
        }

        for i in 0..<5 {
            let view = DontBeCustomInfoView()
            self.setTransparencyInfoView(view: view)
            DontBeTransparencyInfoView.pushCount += 1
            
            infoContentView.addSubview(view)
            
            view.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalToSuperview().inset((339 * i).adjusted)
                $0.width.equalTo(339.adjusted)
            }
            
            if i == 4 {
                infoContentView.snp.makeConstraints {
                    $0.trailing.equalTo(view.snp.trailing)
                }
                DontBeTransparencyInfoView.pushCount = 0
            }
        }
    }
    
    private func setTransparencyInfoView(view: DontBeCustomInfoView) {
        view.InfoImage.image = self.dummy[DontBeTransparencyInfoView.pushCount].infoImage
        view.title.text = self.dummy[DontBeTransparencyInfoView.pushCount].title
        view.content.text = self.dummy[DontBeTransparencyInfoView.pushCount].content
    }
}
