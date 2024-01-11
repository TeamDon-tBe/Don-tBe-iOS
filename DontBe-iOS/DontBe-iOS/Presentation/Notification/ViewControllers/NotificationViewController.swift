//
//  NotificationViewController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/12/24.
//

import UIKit

import SnapKit

final class NotificationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let dummy = NotificationDummy.dummy()
    
    // MARK: - UI Components
    
    private let notificationTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .donGray1
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70.adjusted
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()
    
    // MARK: - Life Cycles

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        setRegisterCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = false
    }
}

// MARK: - Extensions

extension NotificationViewController {
    private func setUI() {
        self.view.backgroundColor = .donGray1
        self.navigationItem.title = StringLiterals.Notification.alarm
        self.navigationController?.navigationBar.barTintColor = .donWhite
        self.navigationController?.navigationBar.backgroundColor = .donWhite
    }
    
    private func setHierarchy() {
        self.view.addSubview(notificationTableView)
    }
    
    private func setLayout() {
        notificationTableView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(6.adjusted)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1000.adjusted)
        }
    }
    
    private func setDelegate() {
        self.notificationTableView.delegate = self
        self.notificationTableView.dataSource = self
    }
    
    private func setRegisterCell() {
        NotificationTableViewCell.register(tableView: notificationTableView)
    }
}

extension NotificationViewController: UITableViewDelegate { }
extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.reuseIdentifier, for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }
        cell.configureCell(item: dummy[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
