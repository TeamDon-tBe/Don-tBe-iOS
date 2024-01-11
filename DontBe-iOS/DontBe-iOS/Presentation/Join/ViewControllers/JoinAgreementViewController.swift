//
//  JoinViewController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/10/24.
//
import Combine
import UIKit

import SnapKit

final class JoinAgreementViewController: UIViewController {
    
    // MARK: - Properties
    
    private var cancelBag = CancelBag()
    private let viewModel: JoinAgreeViewModel
    
    private lazy var backButtonTapped = self.navigationBackButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var allCheckButtonTapped = self.originView.allCheck.checkButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var firstCheck = self.originView.firstCheckView.checkButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var secondCheck = self.originView.secondCheckView.checkButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var thirdCheck = self.originView.thirdCheckView.checkButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var fourtchCheck = self.originView.fourthCheckView.checkButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var nextButtonTapped = self.originView.nextActiveButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    
    
    // MARK: - UI Components
    
    private var navigationBackButton = BackButton()
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
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        setHierarchy()
        setLayout()
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
        let input = JoinAgreeViewModel.Input(
            backButtonTapped: backButtonTapped,
            allCheckButtonTapped: allCheckButtonTapped,
            firstCheckButtonTapped: firstCheck,
            secondCheckButtonTapped: secondCheck,
            thirdCheckButtonTapped: thirdCheck,
            fourthCheckButtonTapped: fourtchCheck,
            nextButtonTapped: nextButtonTapped)
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        let allCheckButton = self.originView.allCheck.checkButton
        let checkButtons = [
            self.originView.firstCheckView.checkButton,
            self.originView.secondCheckView.checkButton,
            self.originView.thirdCheckView.checkButton,
            self.originView.fourthCheckView.checkButton
        ]
        
        output.popViewController
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: self.cancelBag)
        
        output.clickedButtonState
            .sink { [weak self] index, isClicked in
                guard let self = self else { return }
                let checkImage = isClicked ? ImageLiterals.Join.btnCheckBox : ImageLiterals.Join.btnNotCheckBox
                
                switch index {
                case 1:
                    // 첫 번째 버튼 UI 업데이트
                    self.originView.firstCheckView.checkButton.setImage(checkImage, for: .normal)
                case 2:
                    // 두 번째 버튼 UI 업데이트
                    self.originView.secondCheckView.checkButton.setImage(checkImage, for: .normal)
                case 3:
                    // 세 번째 버튼 UI 업데이트
                    self.originView.thirdCheckView.checkButton.setImage(checkImage, for: .normal)
                case 4:
                    // 네 번째 버튼 UI 업데이트
                    self.originView.fourthCheckView.checkButton.setImage(checkImage, for: .normal)
                default:
                    break
                }
            }
            .store(in: self.cancelBag)
        
        output.isAllcheck
            .sink { isNextButtonEnabled in
                let checkImage = isNextButtonEnabled ? ImageLiterals.Join.btnCheckBox : ImageLiterals.Join.btnNotCheckBox
                allCheckButton.setImage(checkImage, for: .normal)
                
                checkButtons.forEach { button in
                    button.setImage(checkImage, for: .normal)
                }
            }
            .store(in: self.cancelBag)
        
        output.isEnable
            .sink { value in
                if value == 0 {
                    self.originView.nextActiveButton.isHidden = false
                    self.originView.allCheck.checkButton.setImage(ImageLiterals.Join.btnCheckBox, for: .normal)
                } else if value == 1 {
                    self.originView.nextActiveButton.isHidden = false
                    self.originView.allCheck.checkButton.setImage(ImageLiterals.Join.btnNotCheckBox, for: .normal)
                } else {
                    self.originView.nextActiveButton.isHidden = true
                    self.originView.allCheck.checkButton.setImage(ImageLiterals.Join.btnNotCheckBox, for: .normal)
                }
            }
            .store(in: self.cancelBag)
        
        output.pushViewController
            .sink { _ in
                let viewController = JoinProfileViewController(viewModel: JoinProfileViewModel())
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            .store(in: self.cancelBag)
    }
}
