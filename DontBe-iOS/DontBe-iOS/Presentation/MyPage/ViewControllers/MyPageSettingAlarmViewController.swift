//
//  MyPageSettingAlarmViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 6/19/24.
//

import UIKit

final class MyPageSettingAlarmViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let topDivisionLine = UIView().makeDivisionLine()
    
    private let pushAlarmSettingView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let pushAlarmTitle: UILabel = {
        let label = UILabel()
        label.text = "푸시 알림"
        label.font = .font(.body3)
        label.textColor = .donBlack
        return label
    }()
    
    private let pushAlarmSettingLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.body4)
        label.textColor = .donGray7
        return label
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
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
        
        isNotificationEnabled { isEnabled in
            if isEnabled {
                self.pushAlarmSettingLabel.text = "on >"
            } else {
                self.pushAlarmSettingLabel.text = "off >"
            }
        }
    }
}

// MARK: - Extensions

extension MyPageSettingAlarmViewController {
    private func setUI() {
        self.title = StringLiterals.MyPage.MyPageSettingAlarmNavigationTitle
        self.view.backgroundColor = .donWhite
        
        self.navigationController?.navigationBar.backgroundColor = .donWhite
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
    }
    
    private func setHierarchy() {
        self.view.addSubviews(topDivisionLine,
                              pushAlarmSettingView)
        
        pushAlarmSettingView.addSubviews(pushAlarmTitle,
                                         pushAlarmSettingLabel)
    }
    
    private func setLayout() {
        topDivisionLine.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.adjusted)
        }
        
        pushAlarmSettingView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48.adjusted)
        }
        
        pushAlarmTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16.adjusted)
        }
        
        pushAlarmSettingLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15.adjusted)
        }
    }
    
    private func setAddTarget() {
        pushAlarmSettingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushAlarmSettingButtonTapped)))
    }
    
    // 알림 설정을 확인하는 함수
    @objc
    private func isNotificationEnabled(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
    
    @objc
    private func pushAlarmSettingButtonTapped() {
        if let alarmSettings = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(alarmSettings) {
                UIApplication.shared.open(alarmSettings, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: false)
    }
}
