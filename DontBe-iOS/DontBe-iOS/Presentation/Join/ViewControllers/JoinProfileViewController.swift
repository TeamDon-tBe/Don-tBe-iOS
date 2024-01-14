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
        self.view.backgroundColor = .donGray1
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
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTisEmpty), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    private func bindViewModel() {
        let input = JoinProfileViewModel.Input(backButtonTapped: backButtonTapped, duplicationCheckButtonTapped: duplicationCheckButtonTapped, finishButtonTapped: finishButtonTapped)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.pushOrPopViewController
            .sink { value in
                if value == 0 {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    saveUserData(UserInfo(isSocialLogined: true,
                                          isJoinedApp: true, 
                                          isOnboardingFinished: false,
                                          userNickname: self.originView.nickNameTextField.text ?? ""))
                    
                    let viewContoller = OnboardingViewController()
                    viewContoller.originView.isFirstUser = true
                    self.navigationBackButton.removeFromSuperview()
                    self.navigationController?.pushViewController(viewContoller, animated: true)
                }
            }
            .store(in: self.cancelBag)
        
        output.isEnable
            .sink { isEnable in
                self.originView.nickNameTextField.resignFirstResponder()
                self.originView.finishActiveButton.isHidden = !isEnable
                if isEnable {
                    self.originView.duplicationCheckDescription.text = StringLiterals.Join.duplicationPass
                    self.originView.duplicationCheckDescription.textColor = .donSecondary
                } else {
                    self.originView.duplicationCheckDescription.text = StringLiterals.Join.duplicationNotPass
                    self.originView.duplicationCheckDescription.textColor = .donError
                }
            }
            .store(in: self.cancelBag)
    }

    @objc
    private func textFieldTisEmpty() {
        self.originView.finishActiveButton.isHidden = true
        self.originView.finishButton.isHidden = false
        self.originView.duplicationCheckDescription.text = StringLiterals.Join.duplicationCheckDescription
        self.originView.duplicationCheckDescription.textColor = .donGray8
    }
}
