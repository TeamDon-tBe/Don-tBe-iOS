//
//  LoginViewController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/8/24.
//

import UIKit

import SnapKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private var cancelBag = CancelBag()
    private let viewModel: LoginViewModel
    private lazy var loginButtonTapped = self.loginButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    
    // MARK: - UI Components
    
    private let loginLogo: UIImageView = {
        let logo = UIImageView()
        logo.image = ImageLiterals.Login.icnLogo
        return logo
    }()
    
    private let loginTitle: UILabel = {
        let title = UILabel()
        title.text = StringLiterals.Login.title
        title.textColor = .black
        title.numberOfLines = 2
        title.font = .font(.head1)
        title.setTextWithLineHeight(text: title.text, lineHeight: 37.adjusted, alignment: .left)
        return title
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Login.btnKakao, for: .normal)
        return button
    }()
    
    // MARK: - Life Cycles
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
    }
}

// MARK: - Extensions

extension LoginViewController {
    private func setUI() {
        view.backgroundColor = .donWhite
    }
    
    private func setHierarchy() {
        self.view.addSubviews(loginLogo,
                              loginTitle,
                              loginButton)
        
    }
    
    private func setLayout() {
        loginLogo.snp.makeConstraints {
            $0.top.equalToSuperview().inset(statusBarHeight + 55.adjusted)
            $0.leading.equalToSuperview().inset(16.adjusted)
            $0.width.equalTo(104.adjusted)
            $0.height.equalTo(98.adjusted)
        }
        
        loginTitle.snp.makeConstraints {
            $0.top.equalTo(loginLogo.snp.bottom).offset(10.adjusted)
            $0.leading.equalToSuperview().inset(26.adjusted)
        }
        
        loginButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(51.adjusted)
            $0.leading.trailing.equalToSuperview().inset(18.adjusted)
            $0.height.equalTo(50.adjusted)
        }
        
        loginButton.imageView?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        let input = LoginViewModel.Input(kakaoButtonTapped: loginButtonTapped)
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.userInfoPublisher
            .receive(on: RunLoop.main)
            .sink { isFirstUser in
                if isFirstUser {
                    // 첫 로그인 유저면 여기
                    let viewController = JoinAgreementViewController(viewModel: JoinAgreeViewModel())
                    self.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    // 이미 가입한 유저면 여기
                    let viewController = OnboardingViewController()
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            .store(in: self.cancelBag)
    }
    
}
