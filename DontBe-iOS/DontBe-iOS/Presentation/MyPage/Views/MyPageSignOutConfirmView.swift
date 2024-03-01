//
//  MyPageSignOutConfirmView.swift
//  DontBe-iOS
//
//  Created by 변상우 on 2/28/24.
//

import UIKit

class MyPageSignOutConfirmView: UIView {

    // MARK: - Properties
    
    var checkButtonState = false
    var signoutReason = ""
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "아래 내용을 확인해주세요!"
        label.textColor = .donBlack
        label.font = UIFont.font(.head1)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray2
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "으앗! \(loadUserData()?.userNickname ?? "돈비")님이 떠나면서\n돈비 전체가 조금 더 흐려지고 있어요!\n그럼에도 정말 떠나실 건가요?"
        label.textColor = .donGray10
        label.font = UIFont.font(.body4)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let yesbeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.MyPage.imgSignout
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    private let infoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "계정을 삭제하기 전에 아래 내용을 꼭 확인해주세요!"
        label.textColor = .donError
        label.font = UIFont.font(.body3)
        return label
    }()
    
    private let info1Label: UILabel = {
        let label = UILabel()
        label.text = "회원님의 게시글, 답글, 좋아요 등은 계정 삭제 후에도 자동으로 삭제되지 않으니 미리 확인해 주세요."
        label.textColor = .donGray12
        label.font = UIFont.font(.body4)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let info2Label: UILabel = {
        let label = UILabel()
        label.text = "계정 삭제 처리된 이메일 아이디는 재가입 방지를 위해 30일간 보존된 후 삭제 처리됩니다."
        label.textColor = .donGray12
        label.font = UIFont.font(.body4)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let info3Label: UILabel = {
        let label = UILabel()
        label.text = "탈퇴와 재가입을 통해 아이디를 교체하며 선량한 이용자들께 피해를 끼치는 행위를 방지하려는 조치 오니 넓은 양해 부탁드립니다."
        label.textColor = .donGray12
        label.font = UIFont.font(.body4)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.MyPage.btnCheckboxMini, for: .normal)
        return button
    }()
    
    private let checkInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "안내사항을 모두 확인하였으며, 이에 동의합니다."
        label.textColor = .donBlack
        label.font = UIFont.font(.body4)
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("계정 삭제하기", for: .normal)
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

extension MyPageSignOutConfirmView {
    private func setUI() {

    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         descriptionBackGroundView,
                         descriptionLabel,
                         yesbeImage,
                         infoTitleLabel,
                         info1Label,
                         info2Label,
                         info3Label,
                         checkButton,
                         checkInfoLabel,
                         deleteButton)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(23.adjusted)
            $0.leading.equalToSuperview().inset(22.adjusted)
        }
        
        descriptionBackGroundView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(23.adjusted)
            $0.leading.equalTo(titleLabel.snp.leading).offset(2)
            $0.trailing.equalToSuperview().inset(79.adjusted)
            $0.bottom.equalTo(yesbeImage.snp.bottom).offset(-51.adjusted)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerY.equalTo(descriptionBackGroundView.snp.centerY)
            $0.leading.equalTo(descriptionBackGroundView.snp.leading).offset(14.adjusted)
        }
        
        yesbeImage.snp.makeConstraints {
            $0.top.equalTo(descriptionBackGroundView.snp.top).offset(46.adjusted)
            $0.leading.equalTo(descriptionBackGroundView.snp.leading).offset(197.adjusted)
            $0.height.equalTo(96.adjusted)
        }
        
        infoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(yesbeImage.snp.bottom).offset(18.adjusted)
            $0.leading.equalToSuperview().inset(22.adjusted)
        }
        
        info1Label.snp.makeConstraints {
            $0.top.equalTo(infoTitleLabel.snp.bottom).offset(10.adjusted)
            $0.leading.equalTo(infoTitleLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(22.adjusted)
        }
        
        info2Label.snp.makeConstraints {
            $0.top.equalTo(info1Label.snp.bottom).offset(10.adjusted)
            $0.leading.equalTo(infoTitleLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(22.adjusted)
        }
        
        info3Label.snp.makeConstraints {
            $0.top.equalTo(info2Label.snp.bottom).offset(10.adjusted)
            $0.leading.equalTo(infoTitleLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(22.adjusted)
        }
        
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.adjusted)
            $0.height.equalTo(30.adjusted)
            $0.bottom.equalTo(deleteButton.snp.top).offset(-13.adjusted)
        }
        
        checkInfoLabel.snp.makeConstraints {
            $0.centerY.equalTo(checkButton.snp.centerY)
            $0.leading.equalTo(checkButton.snp.trailing).offset(4.adjusted)
        }
        
        deleteButton.snp.makeConstraints {
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
