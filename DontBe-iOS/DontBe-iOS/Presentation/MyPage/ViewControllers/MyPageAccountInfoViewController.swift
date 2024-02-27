//
//  MyPageAccountInfoViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/12/24.
//

import Combine
import SafariServices
import UIKit

import SnapKit

final class MyPageAccountInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    let userTermURL = URL(string: StringLiterals.MyPage.myPageUseTermURL)
    
    private var cancelBag = CancelBag()
    private let viewModel: MyPageAccountInfoViewModel
    
    private lazy var signOutButtonTapped = self.signOutPopupView.confirmButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    
    var titleData = [
        "소셜 로그인",
        "버전 정보",
        "아이디",
        "가입일"
    ]
    
    // MARK: - UI Components
    
    private var signOutPopupView = DontBePopupView(
        popupTitle: StringLiterals.MyPage.myPageSignOutPopupTitleLabel,
        popupContent: StringLiterals.MyPage.myPageSignOutPopupContentLabel,
        leftButtonTitle: StringLiterals.MyPage.myPageSignOutPopupLeftButtonTitle,
        rightButtonTitle: StringLiterals.MyPage.myPageSignOutPopupRightButtonTitle
    )
    
    private let topDivisionLine = UIView().makeDivisionLine()
    
    private let accountInfoTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.donGray2.cgColor
        return tableView
    }()
    
    private let seperateView: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray2
        return view
    }()
    
    private let moreInfoTitle: UILabel = {
        let label = UILabel()
        label.font = .font(.body3)
        label.text = StringLiterals.MyPage.myPageMoreInfoTitle
        label.textColor = .donBlack
        return label
    }()
    
    private let moreInfoButton: UIButton = {
        let button = UIButton()
        button.setTitle(StringLiterals.MyPage.myPageMoreInfoButtonTitle, for: .normal)
        button.setTitleColor(.donGray7, for: .normal)
        button.titleLabel?.font = .font(.body4)
        return button
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle(StringLiterals.MyPage.myPageSignOutButtonTitle, for: .normal)
        button.setTitleColor(.donGray7, for: .normal)
        button.titleLabel?.font = .font(.body4)
        return button
    }()
    
    // MARK: - Life Cycles
    
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
        setAddTarget()
        setDelegate()
        setRegisterCell()
        bindViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        
        let backButton = UIBarButtonItem.backButton(target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
}

// MARK: - Extensions

extension MyPageAccountInfoViewController {
    private func setUI() {
        self.title = StringLiterals.MyPage.MyPageAccountInfoNavigationTitle
        self.view.backgroundColor = .donWhite
        
        self.navigationController?.navigationBar.backgroundColor = .donWhite
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        
        addUnderline(to: moreInfoButton)
        addUnderline(to: signOutButton)
        
        self.signOutPopupView.isHidden = true
    }
    
    private func setHierarchy() {
        self.view.addSubviews(topDivisionLine,
                              accountInfoTableView,
                              seperateView,
                              moreInfoTitle,
                              moreInfoButton,
                              signOutButton)
        
        if let window = UIApplication.shared.keyWindowInConnectedScenes {
            window.addSubviews(self.signOutPopupView)
        }
    }
    
    private func setLayout() {
        topDivisionLine.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.adjusted)
        }
        
        accountInfoTableView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo((48.adjustedH * 4))
        }
        
        seperateView.snp.makeConstraints {
            $0.top.equalTo(accountInfoTableView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(8.adjusted)
        }
        
        moreInfoTitle.snp.makeConstraints {
            $0.top.equalTo(seperateView.snp.bottom).offset(14.adjusted)
            $0.leading.equalToSuperview().inset(16.adjusted)
        }
        
        moreInfoButton.snp.makeConstraints {
            $0.top.equalTo(seperateView.snp.bottom).offset(14.adjusted)
            $0.trailing.equalToSuperview().inset(15.adjusted)
        }
        
        signOutButton.snp.makeConstraints {
            $0.top.equalTo(moreInfoButton.snp.bottom).offset(27.adjusted)
            $0.trailing.equalTo(moreInfoButton.snp.trailing)
        }
        
        self.signOutPopupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setAddTarget() {
        moreInfoButton.addTarget(self, action: #selector(useTermButtonTapped), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(showSignOutPopup), for: .touchUpInside)
    }
    
    private func setDelegate() {
        self.accountInfoTableView.dataSource = self
        self.accountInfoTableView.delegate = self
        self.signOutPopupView.delegate = self
    }
    
    private func setRegisterCell() {
        self.accountInfoTableView.register(MyPageAccountInfoTableViewCell.self, forCellReuseIdentifier: "MyPageAccountInfoTableViewCell")
    }
    
    private func setDataBind() {
        
    }
    
    private func bindViewModel() {
        let memberId = loadUserData()?.memberId ?? 0
        let input = MyPageAccountInfoViewModel.Input(
            viewAppear: Just(()).eraseToAnyPublisher(),
            signOutButtonTapped: signOutButtonTapped)
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.getAccountInfoData
            .receive(on: RunLoop.main)
            .sink { _ in
                self.accountInfoTableView.reloadData()
            }
            .store(in: self.cancelBag)
        
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
                                              memberId: loadUserData()?.memberId ?? 0,
                                              userProfileImage: loadUserData()?.userProfileImage ?? StringLiterals.Network.baseImageURL))
                        
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
    
    func addUnderline(to button: UIButton) {
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.donGray7
        ]

        let attributedString = NSAttributedString(string: button.currentTitle ?? "", attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
    }
    
    func showSignOutPopupView() {
        self.signOutPopupView.isHidden = false
    }
    
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func useTermButtonTapped() {
        let useTermView: SFSafariViewController
        if let useTermURL = self.userTermURL {
            useTermView = SFSafariViewController(url: useTermURL)
            self.present(useTermView, animated: true, completion: nil)
        }
    }
    
    @objc
    private func showSignOutPopup() {
        showSignOutPopupView()
        // 계정 삭제 사유 뷰로 이동(1차 앱 심사에서 보류)
//        let signOutViewController = MyPageSignOutViewController()
//        self.navigationController?.pushViewController(signOutViewController, animated: true)
    }
}

extension MyPageAccountInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.adjustedH
    }
}

extension MyPageAccountInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.myPageMemberData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageAccountInfoTableViewCell", for: indexPath) as! MyPageAccountInfoTableViewCell
        cell.backgroundColor = .donWhite
        cell.infoTitle.text = titleData[indexPath.row]
        cell.infoContent.text = viewModel.myPageMemberData[indexPath.row]
        return cell
    }
}

extension MyPageAccountInfoViewController: DontBePopupDelegate {
    func cancleButtonTapped() {
        self.signOutPopupView.isHidden = true
    }
    
    func confirmButtonTapped() {
        self.signOutPopupView.isHidden = true
        print("계정삭제 완료")
    }
}
