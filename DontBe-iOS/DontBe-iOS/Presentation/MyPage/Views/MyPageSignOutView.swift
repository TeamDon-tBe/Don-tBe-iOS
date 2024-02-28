//
//  MyPageSignOutView.swift
//  DontBe-iOS
//
//  Created by 변상우 on 2/12/24.
//

import UIKit

class MyPageSignOutView: UIView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "정말 떠나시는 건가요?\n한번 더 생각해보지 않으시겠어요?"
        label.textColor = .donBlack
        label.font = UIFont.font(.head2)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "계정을 삭제하시려는 이유를 말씀해주세요.\n제품 개선에 중요한 자료로 활용하겠습니다."
        label.textColor = .donGray8
        label.font = UIFont.font(.body4)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let firstReasonView = DontBePopupReasonListCustomView(reason: "온화하지 못한 내용이 많이 보여요")
    let secondReasonView = DontBePopupReasonListCustomView(reason: "원하는 콘텐츠가 없어요")
    let thirdReasonView = DontBePopupReasonListCustomView(reason: "필요한 커뮤니티 기능이 없어요")
    let fourthReasonView = DontBePopupReasonListCustomView(reason: "자주 사용하지 않아요")
    let fifthReasonView = DontBePopupReasonListCustomView(reason: "앱 오류가 있어 사용하기 불편해요")
    let sixthReasonView = DontBePopupReasonListCustomView(reason: "가입할 때 사용한 소셜 계정이 바뀔 예정이에요")
    let seventhReasonView = DontBePopupReasonListCustomView(reason: "기타")
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("계속", for: .normal)
        button.setTitleColor(.donGray9, for: .normal)
        button.titleLabel?.font = UIFont.font(.body3)
        button.backgroundColor = .donGray4
        button.layer.cornerRadius = 6.adjusted
        button.isEnabled = false
        return button
    }()
    
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

extension MyPageSignOutView {
    private func setUI() {

    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         descriptionLabel,
                         firstReasonView,
                         secondReasonView,
                         thirdReasonView,
                         fourthReasonView,
                         fifthReasonView,
                         sixthReasonView,
                         seventhReasonView,
                         continueButton)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(23.adjusted)
            $0.leading.equalToSuperview().inset(22.adjusted)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10.adjusted)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        firstReasonView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(27.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30.adjusted)
        }
        
        secondReasonView.snp.makeConstraints {
            $0.top.equalTo(firstReasonView.snp.bottom).offset(14.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30.adjusted)
        }
        
        thirdReasonView.snp.makeConstraints {
            $0.top.equalTo(secondReasonView.snp.bottom).offset(14.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30.adjusted)
        }
        
        fourthReasonView.snp.makeConstraints {
            $0.top.equalTo(thirdReasonView.snp.bottom).offset(14.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30.adjusted)
        }
        
        fifthReasonView.snp.makeConstraints {
            $0.top.equalTo(fourthReasonView.snp.bottom).offset(14.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30.adjusted)
        }
        
        sixthReasonView.snp.makeConstraints {
            $0.top.equalTo(fifthReasonView.snp.bottom).offset(14.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30.adjusted)
        }
        
        seventhReasonView.snp.makeConstraints {
            $0.top.equalTo(sixthReasonView.snp.bottom).offset(14.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30.adjusted)
        }
        
        continueButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.adjusted)
            $0.bottom.equalToSuperview().inset(29.adjusted)
            $0.height.equalTo(50.adjusted)
        }
    }
    
    private func setAddTarget() {

    }
    
    private func setRegisterCell() {
        
    }
    
    private func setDataBind() {
        
    }
}
