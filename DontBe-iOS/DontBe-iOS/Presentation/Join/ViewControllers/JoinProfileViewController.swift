//
//  JoinProfileViewController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/11/24.
//

import UIKit

import SnapKit

final class JoinProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private var cancelBag = CancelBag()
    private let viewModel: JoinProfileViewModel
    
    private lazy var backButtonTapped = navigationBackButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
        
    // MARK: - UI Components
    
    private let navigationBackButton = BackButton()
    private let originView = JoinProfileView()
    
    // MARK: - Life Cycles
    
    init(viewModel: JoinProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = originView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
    }
}

// MARK: - Extensions

extension JoinProfileViewController {
    private func setUI() {
        self.view.backgroundColor = .donWhite
        self.navigationItem.title = StringLiterals.Join.joinNavigationTitle
    }
    
    private func setHierarchy() {
        self.navigationController?.navigationBar.addSubviews(navigationBackButton)
        
    }
    
    private func setLayout() {
        navigationBackButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(23.adjusted)
        }
    }
    
    private func bindViewModel() {
        let input = JoinProfileViewModel.Input(backButtonTapped: backButtonTapped)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.popViewController
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: self.cancelBag)
        
    }
}
