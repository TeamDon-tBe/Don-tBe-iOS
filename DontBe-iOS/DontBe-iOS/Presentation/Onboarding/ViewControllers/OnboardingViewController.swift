//
//  OnboardingViewController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/9/24.
//

import UIKit

import SnapKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var cancelBag = CancelBag()
    private let viewModel: OnboardingViewModel
    private lazy var nextButtonTapped = self.nextButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    
    // MARK: - UI Components
        
    private let nextButton = CustomButton(title: "다음으로", backColor: .donBlack, titleColor: .donWhite)
    private let startButton = CustomButton(title: "시작하기", backColor: .donPrimary, titleColor: .donBlack)
    private let skipButton = CustomButton(title: "건너뛰기", backColor: .clear, titleColor: .donGray7)
    
    // MARK: - Life Cycles
    
    init(viewModel: OnboardingViewModel) {
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
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
    }
    
}

// MARK: - Extensions

extension OnboardingViewController {
    private func setUI() {
        self.view.backgroundColor = .donGray1
    }
    
    private func setHierarchy() {
        self.view.addSubviews(nextButton)
    }
    
    private func setLayout() {
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(91.adjusted)
            $0.leading.trailing.equalToSuperview().inset(17.adjusted)
            $0.height.equalTo(50.adjusted)
        }
    }
    
    private func bindViewModel() {
        let input = OnboardingViewModel.Input(nextButtonTapped: nextButtonTapped)
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.voidPublisher
        //            .receive(on: RunLoop.main)
            .sink { _ in
                let viewController = OnboardingViewController(viewModel: OnboardingViewModel())
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            .store(in: self.cancelBag)
    }
    
    
}
