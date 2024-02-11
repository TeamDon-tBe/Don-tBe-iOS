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
        self.navigationItem.hidesBackButton = true
    }
}

// MARK: - Extensions

extension NotificationViewController {
    private func setUI() {
        self.notificationTableView.contentInset = UIEdgeInsets(top: -20.adjustedH, left: 0, bottom: 0, right: 0)
        self.view.backgroundColor = .donWhite
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        self.navigationItem.title = StringLiterals.Notification.alarm
    }
    
    private func setHierarchy() {
        self.view.addSubviews(notificationTableView)
    }
    
    private func setLayout() {
        notificationTableView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
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
            if selectedNotification?.notificationType != .userBan {
                if selectedNotification?.notificationType == .beGhost {
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        DispatchQueue.main.async {
                            let viewController = DontBeTabBarController()
                            viewController.selectedIndex = 3
                            if let selectedViewController = viewController.selectedViewController {
                                viewController.applyFontColorAttributes(to: selectedViewController.tabBarItem, isSelected: true)
                            }
                            sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: viewController)
                        }
                    }
                } else if selectedNotification?.notificationType == .actingContinue {
                    let viewController = WriteViewController(viewModel: WriteViewModel(networkProvider: NetworkService()))
                    self.navigationController?.pushViewController(viewController, animated: false)
                } else {
                    let viewController = PostDetailViewController(viewModel: PostDetailViewModel(networkProvider: NetworkService()))
                    viewController.contentId = selectedNotification?.notificationTriggerId ?? 0
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
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
