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
    private var numsOfLinesOfCellLabel: Int = 0
    
    // MARK: - UI Components
    
    private let refreshControl = UIRefreshControl()
    private let notificationTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .donGray1
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()
    private let notificationTableFooterView: UIView = {
        let notificationTableFooterView = UIView()
        notificationTableFooterView.backgroundColor = .donGray1
        return notificationTableFooterView
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        setRegisterCell()
        setRefreshControll()
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
        self.view.backgroundColor = .donWhite
        self.navigationItem.title = StringLiterals.Notification.alarm
        self.navigationController?.navigationBar.barTintColor = .donWhite
        self.navigationController?.navigationBar.tintColor = .donWhite
        self.navigationController?.navigationBar.backgroundColor = .donWhite
    }
    
    private func setHierarchy() {
        self.view.addSubviews(notificationTableView)
    }
    
    private func setLayout() {
        notificationTableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(statusBarHeight + 15.adjusted)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        self.notificationTableView.delegate = self
        self.notificationTableView.dataSource = self
    }
    
    private func setRegisterCell() {
        NotificationEmptyViewCell.register(tableView: notificationTableView)
        NotificationTableViewCell.register(tableView: notificationTableView)
    }
    
    private func setRefreshControll() {
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        notificationTableView.refreshControl = refreshControl
        refreshControl.backgroundColor = .donGray1
    }
    
    @objc
    func refreshTableView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.notificationTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if numsOfLinesOfCellLabel == 3 {
            return 95.adjustedH
        } else if numsOfLinesOfCellLabel == 4 {
            return 116.adjustedH
        } else {
            return 74.adjustedH
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return notificationTableFooterView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 59.adjusted
    }
}

extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = dummy.count
        if count == 0 {
            return 1
        } else {
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dummy.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationEmptyViewCell.reuseIdentifier, for: indexPath) as? NotificationEmptyViewCell else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.reuseIdentifier, for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }
            cell.configureCell(item: dummy[indexPath.row])
            cell.selectionStyle = .none
            let numsOflines =  UILabel.lineNumber(label: cell.notificationLabel, labelWidth: 216.adjusted)
            numsOfLinesOfCellLabel = numsOflines
            return cell
        }
    }
}
