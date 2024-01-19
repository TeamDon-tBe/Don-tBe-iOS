//
//  MyPageEditProfileViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/12/24.
//

import UIKit

import SnapKit

final class MyPageEditProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    static let showWriteToastNotification = Notification.Name("ShowWriteToastNotification")
    
    private var cancelBag = CancelBag()
    private let viewModel: MyPageProfileViewModel
    
    private lazy var backButtonTapped = navigationBackButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var duplicationCheckButtonTapped = self.nicknameEditView.duplicationCheckButton.publisher(for: .touchUpInside).map { _ in
        return self.nicknameEditView.nickNameTextField.text ?? ""
    }.eraseToAnyPublisher()
    private lazy var postButtonTapped = self.introductionEditView.postActiveButton.publisher(for: .touchUpInside).map { _ in
        return UserProfileRequestDTO(nickname: self.nicknameEditView.nickNameTextField.text ?? "",
                                     is_alarm_allowed: true,
                                     member_intro: self.introductionEditView.contentTextView.text ?? "",
                                     profile_url: StringLiterals.Network.baseImageURL)
    }.eraseToAnyPublisher()
    
    var isTrue: Bool = true
    var nickname: String = ""
    var introText: String = ""

    // MARK: - UI Components
    
    private let navigationBackButton = BackButton()
    let nicknameEditView = MyPageNicknameEditView()
    let introductionEditView = MyPageIntroductionEditView()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        bindViewModel()
    }
    
    init(viewModel: MyPageProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        
        let backButton = UIBarButtonItem.backButton(target: self, action: #selector(navBackButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
        if introText == "" {
            self.introductionEditView.contentTextView.addPlaceholder(StringLiterals.MyPage.myPageEditIntroductionPlease, padding: UIEdgeInsets(top: 14.adjusted, left: 14.adjusted, bottom: 14.adjusted, right: 14.adjusted))
        } else {
            self.nicknameEditView.nickNameTextField.text = nickname
            self.introductionEditView.contentTextView.text = introText
        }
    }
}

// MARK: - Extensions

extension MyPageEditProfileViewController {
    private func setUI() {
        self.title = StringLiterals.MyPage.MyPageEditNavigationTitle
        self.view.backgroundColor = .donWhite
        self.title = StringLiterals.MyPage.MyPageEditNavigationTitle
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func setHierarchy() {
        self.view.addSubviews(nicknameEditView,
                              introductionEditView)
    }
    
    private func setLayout() {
        nicknameEditView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(323.adjusted)
        }
        
        introductionEditView.snp.makeConstraints {
            $0.top.equalTo(nicknameEditView.duplicationCheckDescription.snp.bottom).offset(16.adjustedH)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setDelegate() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTisEmpty), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    private func bindViewModel() {
        let input = MyPageProfileViewModel.Input(backButtonTapped: backButtonTapped, duplicationCheckButtonTapped: duplicationCheckButtonTapped, finishButtonTapped: postButtonTapped)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.popViewController
            .receive(on: RunLoop.main)
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: self.cancelBag)
        
        output.isEnable
            .receive(on: RunLoop.main)
            .sink { isEnable in
                print("\(isEnable)")
                self.nicknameEditView.nickNameTextField.resignFirstResponder()
                self.introductionEditView.postActiveButton.isHidden = !isEnable
                if isEnable {
                    // 닉네임 사용 가능
                    self.nicknameEditView.duplicationCheckDescription.text = StringLiterals.Join.duplicationPass
                    self.nicknameEditView.duplicationCheckDescription.textColor = .donSecondary
                    self.introductionEditView.postButton.isHidden = true
                    self.introductionEditView.postActiveButton.isHidden = false
                } else {
                    // 닉네임 중복
                    self.nicknameEditView.duplicationCheckDescription.text = StringLiterals.Join.duplicationNotPass
                    self.nicknameEditView.duplicationCheckDescription.textColor = .donError
                    self.introductionEditView.postButton.isHidden = false
                    self.introductionEditView.postActiveButton.isHidden = true
                }
            }
            .store(in: self.cancelBag)
    }
    
    @objc
    private func textFieldTisEmpty() {
        self.introductionEditView.postButton.isHidden = false
        self.introductionEditView.postActiveButton.isHidden = true
    }
    
    @objc
    private func navBackButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
