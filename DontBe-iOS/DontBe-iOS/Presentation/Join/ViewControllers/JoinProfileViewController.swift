//
//  JoinProfileViewController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/11/24.
//

import UIKit

import SnapKit

final class JoinProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private var cancelBag = CancelBag()
    private let viewModel: JoinProfileViewModel
    
    private lazy var backButtonTapped = navigationBackButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var duplicationCheckButtonTapped = self.originView.duplicationCheckButton.publisher(for: .touchUpInside).map { _ in
        return self.originView.nickNameTextField.text ?? ""
    }.eraseToAnyPublisher()
    private lazy var finishButtonTapped = self.originView.finishActiveButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    
    // MARK: - UI Components
    
    private let navigationBackButton = BackButton()
    private let originView = JoinProfileView()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Life Cycles
    
    init(viewModel: JoinProfileViewModel) {
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
        setHierarchy()
        setLayout()
        setDelegate()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
    }
}

// MARK: - Extensions

extension JoinProfileViewController {
    private func setUI() {
        self.view.backgroundColor = .donWhite
        self.navigationItem.title = StringLiterals.Join.joinNavigationTitle
    }
    
    private func setHierarchy() {
        self.navigationController?.navigationBar.addSubviews(navigationBackButton)
        
    }
    
    private func setLayout() {
        navigationBackButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(23.adjusted)
        }
    }
    
    private func setDelegate() {
        self.originView.nickNameTextField.delegate = self
    }
    
    private func bindViewModel() {
        let input = JoinProfileViewModel.Input(backButtonTapped: backButtonTapped, duplicationCheckButtonTapped: duplicationCheckButtonTapped, finishButtonTapped: finishButtonTapped)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.pushOrPopViewController
            .sink { value in
                if value == 0 {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    // UserInfo 인스턴스 생성
                    let userNickname = UserInfo(userNickname: self.originView.nickNameTextField.text ?? "")
                    // Local DB에 저장
                    UserDefaults.standard.set(userNickname.userNickname, forKey: "nickname")
                    
                    let viewContoller = OnboardingViewController()
                    self.navigationBackButton.removeFromSuperview()
                    self.navigationController?.pushViewController(viewContoller, animated: true)
                }
            }
            .store(in: self.cancelBag)
        
        output.isEnable
            .sink { isTrue in
                self.originView.nickNameTextField.resignFirstResponder()
                self.originView.finishActiveButton.isHidden = !isTrue
                if isTrue {
                    self.originView.duplicationCheckDescription.text = StringLiterals.Join.duplicationPass
                    self.originView.duplicationCheckDescription.textColor = .donSecondary
                } else {
                    self.originView.duplicationCheckDescription.text = StringLiterals.Join.duplicationNotPass
                    self.originView.duplicationCheckDescription.textColor = .donError
                }
            }
            .store(in: self.cancelBag)
    }
}

// MARK: - UITextFieldDelegate

extension JoinProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 12 // 글자수 제한
        let oldText = textField.text ?? "" // 입력하기 전 textField에 표시되어있던 text
        let addedText = string // 입력한 text
        let newText = oldText + addedText // 입력하기 전 text와 입력한 후 text를 합침
        let newTextLength = newText.count // 합쳐진 text의 길이
        
        // 글자수 제한
        if newTextLength <= maxLength {
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
        let maxLength = 12 // 글자 수 제한
        if text.count >= maxLength {
            let startIndex = text.startIndex
            let endIndex = text.index(startIndex, offsetBy: maxLength - 1)
            let fixedText = String(text[startIndex...endIndex])
            textField.text = fixedText
            self.originView.numOfLetters.text = "12/12"
        } else {
            self.originView.numOfLetters.text = "\(text.count)/12"
        }
    }
}
