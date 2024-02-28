//
//  OnboardingEndingView.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/12/24.
//

import UIKit

import SnapKit

final class OnboardingEndingView: UIView {
        
    // MARK: - UI Components
    private let progressImage: UIImageView = {
        let progress = UIImageView()
        progress.image = ImageLiterals.Onboarding.progressbar4
        return progress
    }()
    
    private let titleImage: UIImageView = {
        let title = UIImageView()
        title.image = ImageLiterals.Onboarding.imgFourthTitle
        title.contentMode = .scaleAspectFit
        return title
    }()
    
    let profileImage: UIImageView = {
        let profile = UIImageView()
        profile.contentMode = .scaleAspectFill
        profile.layer.cornerRadius = profile.frame.width / 2
        return profile
    }()
    
    let introductionView = IntroductionView()
    
    let backButton = BackButton()
    
    let startButton: UIButton = {
        let startButton = UIButton()
        startButton.setTitle(StringLiterals.Button.start, for: .normal)
        startButton.titleLabel?.font = .font(.body3)
        startButton.backgroundColor = .donGray4
        startButton.setTitleColor(.donGray9, for: .normal)
        startButton.layer.cornerRadius = 6.adjusted
        startButton.isEnabled = false
        return startButton
    }()
    
    let laterButton = CustomButton(title: StringLiterals.Button.later, backColor: .clear, titleColor: .donGray7)
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setDelegate()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension OnboardingEndingView {
    private func setHierarchy() {
        self.addSubviews(backButton,
                         progressImage,
                         titleImage,
                         profileImage,
                         introductionView,
                         startButton,
                         laterButton)
        self.bringSubviewToFront(profileImage)
    }
    
    private func setLayout() {
        let statusBarHeight = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .statusBarManager?
            .statusBarFrame.height ?? 20
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(statusBarHeight + 38.adjusted)
            $0.leading.equalToSuperview().inset(23.adjusted)
        }
        
        progressImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(statusBarHeight + 46.adjusted)
            $0.width.equalTo(48.adjusted)
            $0.height.equalTo(6.adjusted)
        }
        
        titleImage.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(91.adjusted)
            $0.top.equalToSuperview().inset(statusBarHeight + 90.adjustedH)
            $0.height.equalTo(72.adjusted)
        }
        
        profileImage.snp.makeConstraints {
            $0.size.equalTo(100.adjusted)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(statusBarHeight + 186.adjustedH)
        }
        
        introductionView.snp.makeConstraints {
            $0.width.equalTo(320.adjusted)
            $0.height.equalTo(229.adjusted)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImage).offset(50.adjusted)
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(91.adjusted)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(342.adjusted)
            $0.height.equalTo(50.adjusted)
        }
        
        laterButton.snp.makeConstraints {
            $0.top.equalTo(startButton.snp.bottom).offset(12.adjusted)
            $0.centerX.equalToSuperview()
            
        }
    }
    
    private func setDelegate() {
        self.introductionView.introduction.delegate = self
    }
}

extension OnboardingEndingView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // 키보드 내리면서 동작
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text ?? "" // 입력하기 전 textField에 표시되어있던 text
        let addedText = string // 입력한 text
        let newText = oldText + addedText // 입력하기 전 text와 입력한 후 text를 합침
        let newTextLength = newText.count // 합쳐진 text의 길이
        
        // 글자수 제한
        if newTextLength > 0 {
            return true
        }
        
        let lastWordOfOldText = String(oldText[oldText.index(before: oldText.endIndex)]) // 입력하기 전 text의 마지막 글자
        let separatedCharacters = lastWordOfOldText.decomposedStringWithCanonicalMapping.unicodeScalars.map{ String($0) } // 입력하기 전 text의 마지막 글자를 자음과 모음으로 분리
        let separatedCharactersCount = separatedCharacters.count // 분리된 자음, 모음의 개수
        
        if separatedCharactersCount == 1 && !addedText.isConsonant {
            return true
        } else if separatedCharactersCount == 2 && addedText.isConsonant {
            return true
        } else if separatedCharactersCount == 3 && addedText.isConsonant {
            return true
        }
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? "" // textField에 수정이 반영된 후의 text
        if text.count > 0 {
            self.startButton.isEnabled = true
            self.startButton.setTitleColor(.donBlack, for: .normal)
            self.startButton.backgroundColor = .donPrimary
        } else {
            self.startButton.isEnabled = false
            self.startButton.setTitleColor(.donGray9, for: .normal)
            self.startButton.backgroundColor = .donGray4
        }
    }
}

