//
//  DontBeToastView.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/10/24.
//

import UIKit

import SnapKit

final class DontBeToastView: UIView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray3
        view.layer.cornerRadius = 4.adjusted
        return view
    }()
    
    let circleProgressBar: CircleProgressbar = {
        let circle = CircleProgressbar()
        circle.backgroundColor = .clear
        circle.circleTintColor = .donPrimary
        circle.circleBackgroundColor = .donWhite
        return circle
    }()
    
    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.Toast.icnCheck
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let toastLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.Toast.uploading
        label.textColor = .donBlack
        label.textAlignment = .center
        label.font = UIFont.font(.body3)
        return label
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

extension DontBeToastView {
    private func setUI() {
        checkImageView.alpha = 0
        circleProgressBar.value = 0
    }
    
    private func setHierarchy() {
        self.addSubview(container)
        container.addSubviews(circleProgressBar, checkImageView, toastLabel)
    }
    
    private func setLayout() {
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        circleProgressBar.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        checkImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(22)
        }
        
        toastLabel.snp.makeConstraints {
            $0.leading.equalTo(circleProgressBar.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
    }
}
