//
//  DontBePopupReasonView.swift
//  DontBe-iOS
//
//  Created by 변상우 on 2/27/24.
//

import UIKit

import SnapKit

protocol DontBePopupReasonDelegate: AnyObject {
    func reasonCancelButtonTapped()
    func reasonConfirmButtonTapped()
}

final class DontBePopupReasonView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: DontBePopupReasonDelegate?
    
    // MARK: - UI Components
    
    private let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = .donBlack
        view.alpha = 0.4
        return view
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .donWhite
        view.layer.cornerRadius = 10.adjusted
        return view
    }()
    
    private let popupTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "투명도 버튼을 눌렀어요"
        label.textColor = .donBlack
        label.textAlignment = .center
        label.font = UIFont.font(.head3)
        return label
    }()
    
    private let popupContentLabel: UILabel = {
        let label = UILabel()
        label.text = "Don’t be의 온화함을 해친다고 생각하셨나요?\n어떤 이유로 누르신 건지 알려주세요!"
        label.textColor = .donGray9
        label.textAlignment = .center
        label.font = UIFont.font(.body4)
        label.numberOfLines = 0
        return label
    }()
    
    let firstReasonView = DontBePopupReasonListCustomView(reason: "누군가를 비하하고 있어요")
    let secondReasonView = DontBePopupReasonListCustomView(reason: "오해를 불러일으키는 내용을 말해요")
    let thirdReasonView = DontBePopupReasonListCustomView(reason: "불쾌한 표현을 사용해요")
    let fourthReasonView = DontBePopupReasonListCustomView(reason: "갈등을 조장하고 있어요")
    let fifthReasonView = DontBePopupReasonListCustomView(reason: "의미가 없는 내용을 도배해요")
    let sixthReasonView = DontBePopupReasonListCustomView(reason: "기타")
    
    let warnLabel: UILabel = {
        let label = UILabel()
        label.text = "투명도 주기를 누르신 사유 1가지를 선택해주세요."
        label.textColor = .donError
        label.font = UIFont.font(.caption3)
        label.isHidden = true
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 12.adjusted
        return stackView
    }()
    
    private let cancleButton: UIButton = {
        let button = UIButton()
        button.setTitle("조금 더 고민하기", for: .normal)
        button.setTitleColor(.donBlack, for: .normal)
        button.titleLabel?.font = UIFont.font(.body3)
        button.backgroundColor = .donGray3
        button.layer.cornerRadius = 4.adjusted
        return button
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("투명도 주기", for: .normal)
        button.setTitleColor(.donWhite, for: .normal)
        button.titleLabel?.font = UIFont.font(.body3)
        button.backgroundColor = .donBlack
        button.layer.cornerRadius = 4.adjusted
        return button
    }()
    
    // MARK: - Life Cycles
    
    init() {
        super.init(frame: .zero)
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

extension DontBePopupReasonView {
    func setUI() {
        self.backgroundColor = .donBlack.withAlphaComponent(0.6)
    }
    
    func setHierarchy() {
        self.addSubviews(dimView, container)
        
        container.addSubviews(popupTitleLabel,
                              popupContentLabel,
                              firstReasonView,
                              secondReasonView,
                              thirdReasonView,
                              fourthReasonView,
                              fifthReasonView,
                              sixthReasonView,
                              warnLabel,
                              buttonStackView)
        
        buttonStackView.addArrangedSubviews(cancleButton,
                                            confirmButton)
    }
    
    func setLayout() {
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        container.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24.adjusted)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(484.adjusted)
        }
        
        popupTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(34.adjusted)
            $0.leading.trailing.equalToSuperview().inset(30.adjusted)
        }
        
        popupContentLabel.snp.makeConstraints {
            $0.top.equalTo(popupTitleLabel.snp.bottom).offset(8.adjusted)
            $0.leading.trailing.equalToSuperview().inset(30.adjusted)
            $0.bottom.equalTo(firstReasonView.snp.top).offset(-26.adjusted)
        }
        
        firstReasonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30.adjusted)
        }
        
        secondReasonView.snp.makeConstraints {
            $0.top.equalTo(firstReasonView.snp.bottom).offset(11.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30.adjusted)
        }
        
        thirdReasonView.snp.makeConstraints {
            $0.top.equalTo(secondReasonView.snp.bottom).offset(11.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30.adjusted)
        }
        
        fourthReasonView.snp.makeConstraints {
            $0.top.equalTo(thirdReasonView.snp.bottom).offset(11.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30.adjusted)
        }
        
        fifthReasonView.snp.makeConstraints {
            $0.top.equalTo(fourthReasonView.snp.bottom).offset(11.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30.adjusted)
        }
        
        sixthReasonView.snp.makeConstraints {
            $0.top.equalTo(fifthReasonView.snp.bottom).offset(11.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30.adjusted)
        }
        
        warnLabel.snp.makeConstraints {
            $0.top.equalTo(sixthReasonView.snp.bottom).offset(15.adjusted)
            $0.leading.equalToSuperview().inset(27.adjusted)
            $0.bottom.equalTo(buttonStackView.snp.top).offset(-15.adjusted)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(20.adjusted)
            $0.height.equalTo(44.adjusted)
        }
    }
    
    func setAddTarget() {
        self.cancleButton.addTarget(self, action: #selector(cancleButtonTapped), for: .touchUpInside)
        self.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func cancleButtonTapped() {
        delegate?.reasonCancelButtonTapped()
    }
    
    @objc
    func confirmButtonTapped() {
        delegate?.reasonConfirmButtonTapped()
    }
}
