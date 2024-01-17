//
//  NotificationViewController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/12/24.
//

import Combine
import UIKit

import SnapKit

final class NotificationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let cancelBag = CancelBag()
    private let viewModel: NotificationViewModel
    private var numsOfLinesOfCellLabel: Int = 0
    
    // MARK: - UI Components
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var refreshControlClicked = refreshControl.refreshControlPublisher.map { _ in
         }.eraseToAnyPublisher()
    
    let notificationTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .donGray1
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    private let notificationTableFooterView: UIView = {
        let notificationTableFooterView = UIView()
        notificationTableFooterView.backgroundColor = .donGray1
        return notificationTableFooterView
    }()
    
    // MARK: - Life Cycles
    
    init(viewModel: NotificationViewModel) {
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
        setRegisterCell()
        setRefreshControll()
        bindViewModel()
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
        self.notificationTableView.refreshControl = refreshControl
        self.refreshControl.backgroundColor = .donGray1
    }
    
    private func bindViewModel() {
        let input = NotificationViewModel.Input(viewLoad: Just(()).eraseToAnyPublisher(), refreshControlClicked: refreshControlClicked)
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)

        output.reloadTableView
            .receive(on: RunLoop.main)
            .sink { value in
                   self.notificationTableView.reloadData()

                   if value == 1 {
                       self.refreshControl.endRefreshing()
                   }
               }
               .store(in: self.cancelBag)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !viewModel.notificationList.isEmpty {
            // 선택한 셀에 해당하는 데이터
            let selectedNotification = viewModel.notificationList[indexPath.row]
            print(selectedNotification ?? 100)
        }
    }
}

extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.notificationList.count
        if count == 0 {
            return 1
        } else {
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.notificationList.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationEmptyViewCell.reuseIdentifier, for: indexPath) as? NotificationEmptyViewCell else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.reuseIdentifier, for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }
            cell.configureCell(list: viewModel.notificationList[indexPath.row] ?? NotificationList.baseList)
            cell.selectionStyle = .none
            let numsOflines =  UILabel.lineNumber(label: cell.notificationLabel, labelWidth: 216.adjusted)
            numsOfLinesOfCellLabel = numsOflines
            return cell
        }
    }
}
