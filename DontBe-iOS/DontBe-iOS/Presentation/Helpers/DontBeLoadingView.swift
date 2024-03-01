//
//  DontBeLoadingView.swift
//  DontBe-iOS
//
//  Created by yeonsu on 3/2/24.
//

import UIKit
import SnapKit
import Lottie

final class DontBeLoadingView: UIView {
    
    private var loadingText: String = ""
    private var loadingTexts = [StringLiterals.Loading.loadingMessage1,
                               StringLiterals.Loading.loadingMessage2,
                               StringLiterals.Loading.loadingMessage3,
                               StringLiterals.Loading.loadingMessage4,
                               StringLiterals.Loading.loadingMessage5,
                               StringLiterals.Loading.loadingMessage6,
                               StringLiterals.Loading.loadingMessage7,
                               StringLiterals.Loading.loadingMessage8]
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()
    
    private let loadingView: LottieAnimationView = {
        let view = LottieAnimationView(name: "loading_yesbe")
        view.loopMode = .loop
        return view
    }()
    
    private let loadingTitle: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.Loading.loadingMessageTitle
        label.textColor = .donBlack
        label.textAlignment = .center
        label.font = UIFont.font(.head2)
        return label
    }()
    
    private var loadingTextLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .donBlack
        label.textAlignment = .center
        label.font = UIFont.font(.body2)
        label.numberOfLines = 0
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .donWhite
        
        selectRandomLoadingText()
        
        self.addSubview(self.contentView)
        self.contentView.addSubviews(self.loadingView,
                                    self.loadingTitle,
                                     self.loadingTextLabel)
        
        self.contentView.snp.makeConstraints {
            $0.center.equalTo(self.safeAreaLayoutGuide)
        }
        self.loadingView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.centerY.equalToSuperview().offset(-100.adjusted)
            $0.size.equalTo(300)
        }
        
        self.loadingTitle.snp.makeConstraints {
            $0.top.equalTo(loadingView.snp.bottom).inset(60.adjusted)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.loadingTextLabel.snp.makeConstraints {
            $0.top.equalTo(loadingTitle.snp.bottom).inset(-16.adjusted)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func selectRandomLoadingText() {
        guard let randomText = loadingTexts.randomElement() else {
            print("Error: Unable to select random loading text.")
            return
        }
        loadingText = randomText
        loadingTextLabel.text = loadingText
    }
    
    func show() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            print("Error: Unable to find key window.")
            return
        }
        
        guard !window.subviews.contains(where: { $0 is DontBeLoadingView }) else {
            print("Error: Loading view is already visible.")
            return
        }
        
        window.addSubview(self)
        self.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.layoutIfNeeded()
        self.loadingView.play()
        UIView.animate(
            withDuration: 0.3,
            animations: { self.contentView.alpha = 1 }
        )
    }
    
    func hide(completion: @escaping () -> () = {}) {
        self.loadingView.stop()
        self.removeFromSuperview()
        completion()
    }
    
    
}
