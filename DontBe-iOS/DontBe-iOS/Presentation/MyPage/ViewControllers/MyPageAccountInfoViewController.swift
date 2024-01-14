//
//  MyPageAccountInfoViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/12/24.
//

import UIKit

import SnapKit

final class MyPageAccountInfoViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    var titleData = [
        "소셜 로그인",
        "버전 정보",
        "아이디",
        "가입일"
    ]
    var infoData = AccountInfoDummy.dummy()
    
    // MARK: - UI Components
    
    private let accountInfoTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
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
        label.text = "이용약관"
        label.textColor = .donBlack
        return label
    }()
    
    private let moreInfoButton: UIButton = {
        let button = UIButton()
        button.setTitle("자세히 보기", for: .normal)
        button.setTitleColor(.donGray7, for: .normal)
        button.titleLabel?.font = .font(.body4)
        return button
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원탈퇴", for: .normal)
        button.setTitleColor(.donGray7, for: .normal)
        button.titleLabel?.font = .font(.body4)
        return button
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAPI()
        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
        setDelegate()
        setRegisterCell()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        
        let backButton = UIBarButtonItem.backButton(target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

// MARK: - Extensions

extension MyPageAccountInfoViewController {
    private func setUI() {
        self.title = "계정 정보"
        self.view.backgroundColor = .donWhite
        
        self.navigationController?.navigationBar.backgroundColor = .donWhite
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        
        addUnderline(to: moreInfoButton)
        addUnderline(to: signOutButton)
    }
    
    private func setHierarchy() {
        self.view.addSubviews(accountInfoTableView,
                              seperateView,
                              moreInfoTitle,
                              moreInfoButton,
                              signOutButton)
    }
    
    private func setLayout() {
        accountInfoTableView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo((48 * 4).adjusted)
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
    }
    
    private func setAddTarget() {

    }
    
    private func setDelegate() {
        self.accountInfoTableView.dataSource = self
        self.accountInfoTableView.delegate = self
    }
    
    private func setRegisterCell() {
        self.accountInfoTableView.register(MyPageAccountInfoTableViewCell.self, forCellReuseIdentifier: "MyPageAccountInfoTableViewCell")
    }
    
    private func setDataBind() {
        
    }
    
    func addUnderline(to button: UIButton) {
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.donGray7
        ]

        let attributedString = NSAttributedString(string: button.currentTitle ?? "", attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
    }

    
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyPageAccountInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.adjusted
    }
}

extension MyPageAccountInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageAccountInfoTableViewCell", for: indexPath) as! MyPageAccountInfoTableViewCell
        cell.backgroundColor = .donWhite
        cell.infoTitle.text = titleData[indexPath.row]
        cell.infoContent.text = infoData[indexPath.row].content
        return cell
    }
}

// MARK: - Network

extension MyPageAccountInfoViewController {
    private func getAPI() {
        
    }
}

//extension ExampleViewController: UICollectionViewDelegate {
//
//}
//
//extension ExampleViewController: UICollectionViewDataSource {
//
//}
//
//extension ExampleViewController: UICollectionViewFlowLayout {
//
//}
