//
//  MyPageSignOutConfirmViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 2/28/24.
//

import UIKit

class MyPageSignOutConfirmViewController: UIViewController {

    // MARK: - Properties
    
    var signOutReason = ""
    
    private var cancelBag = CancelBag()
    private let viewModel: MyPageAccountInfoViewModel
    
    private lazy var signOutButtonTapped = self.signOutPopupView.confirmButton.publisher(for: .touchUpInside).map { _ in
        return self.signOutReason
    }.eraseToAnyPublisher()
    
    // MARK: - UI Components
    
    private let myView = MyPageSignOutConfirmView()
    private var navigationBackButton = BackButton()
    
    private var signOutPopupView = DontBePopupView(
        popupTitle: StringLiterals.MyPage.myPageSignOutPopupTitleLabel,
        popupContent: StringLiterals.MyPage.myPageSignOutPopupContentLabel,
        leftButtonTitle: StringLiterals.MyPage.myPageSignOutPopupLeftButtonTitle,
        rightButtonTitle: StringLiterals.MyPage.myPageSignOutPopupRightButtonTitle
    )
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = myView
    }
    
    init(viewModel: MyPageAccountInfoViewModel) {
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
        setDelegate()
        setAddTarget()
        bindViewModel()
    }
}

// MARK: - Extensions

extension MyPageSignOutConfirmViewController {
    private func setUI() {
        self.title = StringLiterals.MyPage.MyPageSignOutNavigationTitle
        self.view.backgroundColor = .donWhite
        
        self.navigationController?.navigationBar.backgroundColor = .donWhite
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        self.navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem.backButton(target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.signOutPopupView.isHidden = true
    }
    
    private func setHierarchy() {
        if let window = UIApplication.shared.keyWindowInConnectedScenes {
            window.addSubviews(self.signOutPopupView)
        }
    }
    
    private func setLayout() {
        self.signOutPopupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        self.signOutPopupView.delegate = self
    }
    
    private func setAddTarget() {
        self.myView.checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        self.myView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        let memberId = loadUserData()?.memberId ?? 0
        let input = MyPageAccountInfoViewModel.Input(
            viewAppear: nil,
            signOutButtonTapped: signOutButtonTapped)
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.isSignOutResult
            .sink { result in
                if result == 200 {
                    DispatchQueue.main.async {
                        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                            DispatchQueue.main.async {
                                let rootViewController = LoginViewController(viewModel: LoginViewModel(networkProvider: NetworkService()))
                                sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: rootViewController)
                            }
                        }
                        
                        saveUserData(UserInfo(isSocialLogined: false,
                                              isFirstUser: false,
                                              isJoinedApp: true,
                                              isOnboardingFinished: true,
                                              userNickname: loadUserData()?.userNickname ?? "",
                                              memberId: loadUserData()?.memberId ?? 0))
                        
                        OnboardingViewController.pushCount = 0
                    }
                } else if result == 400 {
                    print("존재하지 않는 요청입니다.")
                } else {
                    print("서버 내부에서 오류가 발생했습니다.")
                }
            }
            .store(in: self.cancelBag)
    }
    
    func showSignOutPopupView() {
        self.signOutPopupView.isHidden = false
    }
    
    @objc
    private func checkButtonTapped() {
        if self.myView.checkButtonState == false {
            self.myView.checkButton.setImage(ImageLiterals.MyPage.btnCheckboxSelectedMini, for: .normal)
            
            self.myView.deleteButton.setTitleColor(.donWhite, for: .normal)
            self.myView.deleteButton.backgroundColor = .donBlack
            
            self.myView.deleteButton.isEnabled = true
            self.myView.checkButtonState = true
        } else {
            self.myView.checkButton.setImage(ImageLiterals.MyPage.btnCheckboxMini, for: .normal)
            
            self.myView.deleteButton.setTitleColor(.donGray9, for: .normal)
            self.myView.deleteButton.backgroundColor = .donGray4
            
            self.myView.deleteButton.isEnabled = false
            self.myView.checkButtonState = false
        }
    }
    
    @objc
    private func deleteButtonTapped() {
        showSignOutPopupView()
    }
    
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyPageSignOutConfirmViewController: DontBePopupDelegate {
    func cancleButtonTapped() {
        self.signOutPopupView.isHidden = true
    }
    
    func confirmButtonTapped() {
        self.signOutPopupView.isHidden = true
    }
}
