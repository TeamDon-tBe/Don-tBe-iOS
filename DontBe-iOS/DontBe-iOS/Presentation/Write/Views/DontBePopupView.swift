//
//  DontBePopupView.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/9/24.
//

import UIKit

import SnapKit

protocol DontBePopupDelegate: AnyObject {
    func cancleButtonTapped()
    func confirmButtonTapped()
}

final class DontBePopupView: UIView {

    // MARK: - Properties
    
    weak var delegate: DontBePopupDelegate?
    
    // MARK: - UI Components
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .donWhite
        view.layer.cornerRadius = 10
        return view
    }()
    
    let popupTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donBlack
        label.textAlignment = .center
        label.font = UIFont.font(.body1)
        return label
    }()
    
    let popupContentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .donBlack
        label.textAlignment = .center
        label.font = UIFont.font(.body4)
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    let cancleButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.donBlack, for: .normal)
        button.titleLabel?.font = UIFont.font(.body3)
        button.backgroundColor = .donGray3
        button.layer.cornerRadius = 4
        return button
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.donWhite, for: .normal)
        button.titleLabel?.font = UIFont.font(.body3)
        button.backgroundColor = .donBlack
        button.layer.cornerRadius = 4
        return button
    }()
    
    // MARK: - Life Cycles
    
    init(popupTitle: String, popupContent: String, leftButtonTitle: String, rightButtonTitle: String) {
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
        
        popupTitleLabel.text = popupTitle // 팝업 타이틀
        popupContentLabel.text = popupContent // 팝업 내용
        cancleButton.setTitle(leftButtonTitle, for: .normal) // 팝업 왼쪽 버튼 타이틀
        confirmButton.setTitle(rightButtonTitle, for: .normal) // 팝업 오른쪽 버튼 타이틀
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension DontBePopupView {
    func setUI() {
        self.backgroundColor = .donBlack.withAlphaComponent(0.6)
    }
    
    func setHierarchy() {
        self.addSubview(container)
        
        // 팝업뷰 타이틀이 없는 경우
        if popupTitleLabel.text == nil {
            container.addSubviews(popupContentLabel, buttonStackView)
        } else {
            container.addSubviews(popupTitleLabel, popupContentLabel, buttonStackView)
        }
        
        buttonStackView.addArrangedSubviews(cancleButton, confirmButton)
    }
    
    func setLayout() {
        // 팝업뷰 타이틀이 없는 경우
        if popupTitleLabel.text == nil {
            container.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(24)
                $0.centerY.equalToSuperview()
                $0.height.equalTo(140)
            }
            
            popupContentLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(24)
                $0.leading.trailing.equalToSuperview().inset(18)
                $0.bottom.equalTo(cancleButton.snp.top).offset(-26)
            }
            
            buttonStackView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview().inset(20)
                $0.height.equalTo(44)
            }
        } else {
            container.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(24)
                $0.centerY.equalToSuperview()
            }
        }
    }
    
    func setAddTarget() {
        self.cancleButton.addTarget(self, action: #selector(cancleButtonTapped), for: .touchUpInside)
        self.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func cancleButtonTapped() {
        delegate?.cancleButtonTapped()
    }
    
    @objc
    func confirmButtonTapped() {
        delegate?.confirmButtonTapped()
    }
}
