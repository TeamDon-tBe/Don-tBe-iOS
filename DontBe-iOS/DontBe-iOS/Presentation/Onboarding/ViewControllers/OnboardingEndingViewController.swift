//
//  OnboardingEndingViewController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/9/24.
//

import Combine
import UIKit

import SnapKit

final class OnboardingEndingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var cancelBag = CancelBag()
    private let viewModel: OnboardingEndingViewModel

    private lazy var startButtonTapped = self.originView.startButton.publisher(for: .touchUpInside).map { _
        in saveUserData(UserInfo(isSocialLogined: 
                                 loadUserData()?.isSocialLogined ?? true,
                                 isJoinedApp: true,
                                 isOnboardingFinished: true,
                                 userNickname: loadUserData()?.userNickname ?? ""))
    }.eraseToAnyPublisher()
    private lazy var skipButtonTapped = self.originView.skipButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var backButtonTapped = self.originView.backButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    
    // MARK: - UI Components
    
    private let originView = OnboardingEndingView()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Life Cycles
    
    init(viewModel: OnboardingEndingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = originView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
    }
}

// MARK: - Extensions

extension OnboardingEndingViewController {
    private func setUI() {
        self.view.backgroundColor = .donGray1
    }
    
    private func setDelegate() {
        self.originView.introductionView.introduction.delegate = self
    }
    
    private func bindViewModel() {
        let input = OnboardingEndingViewModel.Input(
            backButtonTapped: backButtonTapped,
            startButtonTapped: startButtonTapped,
            skipButtonTapped: skipButtonTapped)
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.voidPublisher
            .sink { value in
                if value == "back" {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let viewController = DontBeTabBarController()
                    print(self.originView.introductionView.introduction.text ?? "") // 텍스트 필드 텍스트 잘 넘어오는지 확인
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            .store(in: self.cancelBag)
    }
}

extension OnboardingEndingViewController: UITextFieldDelegate {
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
            self.originView.startButton.isEnabled = true
            self.originView.startButton.setTitleColor(.donBlack, for: .normal)
            self.originView.startButton.backgroundColor = .donPrimary
        } else {
            self.originView.startButton.isEnabled = false
            self.originView.startButton.setTitleColor(.donGray9, for: .normal)
            self.originView.startButton.backgroundColor = .donGray4
        }
    }
}

