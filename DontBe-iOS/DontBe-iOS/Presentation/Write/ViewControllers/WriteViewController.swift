//
//  WriteViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/8/24.
//

import UIKit

import SnapKit

final class WriteViewController: UIViewController {
    
    // MARK: - Properties
    
    static let showWriteToastNotification = Notification.Name("ShowWriteToastNotification")
    
    private var cancelBag = CancelBag()
    private let viewModel: WriteViewModel
    private var transparency: Int = 0
    
    private lazy var postButtonTapped = rootView.writeTextView.postButton.publisher(for: .touchUpInside).map { _ in
        return self.rootView.writeTextView.contentTextView.text ?? ""
    }.eraseToAnyPublisher()
    
    // MARK: - UI Components
    
    private let rootView = WriteView()
    private let banView = WriteBanView()
    
    // MARK: - Life Cycles
    
    init(viewModel: WriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAPI()
        bindViewModel()
        
        self.navigationController?.navigationBar.backgroundColor = .donWhite
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .clear
        
        let backButton = UIBarButtonItem(
            title: StringLiterals.Write.writeNavigationBarButtonItemTitle,
            style: .plain,
            target: self,
            action: #selector(cancleNavigationBarButtonTapped)
        )
        
        // 커스텀 백 버튼의 속성 설정 - 색상, 폰트
        backButton.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.donGray11,
            NSAttributedString.Key.font: UIFont.font(.body4)
        ], for: .normal)

        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)

    }
}

// MARK: - Extensions

extension WriteViewController {
    private func setUI() {
        self.view.backgroundColor = .donWhite
        self.title = StringLiterals.Write.writeNavigationTitle
        
        if let window = UIApplication.shared.keyWindowInConnectedScenes {
            window.addSubview(banView)
        }
        
        banView.promiseButton.addTarget(self, action: #selector(promiseButtonTapped), for: .touchUpInside)
    }
    
    private func setDelegate() {
        self.rootView.writeCanclePopupView.delegate = self
    }
    
    private func bindViewModel() {
        let input = WriteViewModel.Input(postButtonTapped: postButtonTapped)
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        output.popViewController
            .sink { _ in
                DispatchQueue.main.async {
                    self.popupNavigation()
                    self.sendData()
                }
            }
            .store(in: self.cancelBag)
    }
    
    private func sendData() {
        NotificationCenter.default.post(name: WriteViewController.showWriteToastNotification, object: nil, userInfo: ["showToast": true])
    }
    
    private func popupNavigation() {
        self.tabBarController?.selectedIndex = 0
        if let selectedViewController = self.tabBarController?.selectedViewController {
            self.applyTabBarAttributes(to: selectedViewController.tabBarItem, isSelected: true)
        }
        let myViewController = self.tabBarController?.viewControllers ?? [UIViewController()]
        for (index, controller) in myViewController.enumerated() {
            if let tabBarItem = controller.tabBarItem {
                if index != self.tabBarController?.selectedIndex {
                    self.applyTabBarAttributes(to: tabBarItem, isSelected: false)
                }
            }
        }
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc
    private func cancleNavigationBarButtonTapped() {
        // 텍스트가 비어있는 경우 POP
        if self.rootView.writeTextView.contentTextView.text == "" {
            popupNavigation()
        } else {
            self.rootView.writeCanclePopupView.alpha = 1
        }
    }
    
    @objc
    private func promiseButtonTapped() {
        self.banView.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Network

extension WriteViewController {
    private func getAPI() {
        if UserDefaults.standard.integer(forKey: "memberGhost") <= -85 {
            self.banView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            self.banView.removeFromSuperview()
        }
    }
}

extension WriteViewController: DontBePopupDelegate {
    func cancleButtonTapped() {
        self.rootView.writeCanclePopupView.alpha = 0
    }
    
    func confirmButtonTapped() {
        self.rootView.writeCanclePopupView.alpha = 0
        popupNavigation()
    }
}
