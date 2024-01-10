//
//  JoinViewController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/10/24.
//

import UIKit

import SnapKit

final class JoinAgreementViewController: UIViewController {
    
    // MARK: - Properties
    
    private var cancelBag = CancelBag()
    private let viewModel: JoinAgreeViewModel
    private lazy var allCheckButtonTapped = self.originView.allCheck.checkButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()

    // MARK: - UI Components
    
    private let navigationBackButton = BackButton()
    private let originView = JoinAgreeView()
    
    // MARK: - Life Cycles
    
    init(viewModel: JoinAgreeViewModel) {
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

extension JoinAgreementViewController {
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
        let input = JoinAgreeViewModel.Input(allCheckButtonTapped: allCheckButtonTapped)
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        let allCheckButton = self.originView.allCheck.checkButton
        let checkButtons = [
            self.originView.firstCheckView.checkButton,
            self.originView.secondCheckView.checkButton,
            self.originView.thirdCheckView.checkButton,
            self.originView.fourthCheckView.checkButton
        ]
        
        output.isAllChecked
            .sink { isChecked in
                let checkImage = isChecked ? ImageLiterals.Join.btnCheckBox : ImageLiterals.Join.btnNotCheckBox
                allCheckButton.setImage(checkImage, for: .normal)
                
                checkButtons.forEach { button in
                    button.setImage(checkImage, for: .normal)
                }
                
                if isChecked {
                    self.originView.nextActiveButton.isHidden = false
                } else {
                    self.originView.nextActiveButton.isHidden = true

                }

            }
            .store(in: self.cancelBag)
    }
}
