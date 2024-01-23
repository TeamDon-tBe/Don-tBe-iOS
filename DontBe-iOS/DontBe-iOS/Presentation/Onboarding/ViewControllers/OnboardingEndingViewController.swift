//
//  OnboardingEndingViewController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/9/24.
//

import Combine
import UIKit

import SnapKit

final class OnboardingEndingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var cancelBag = CancelBag()
    private let viewModel: OnboardingEndingViewModel

    private lazy var startButtonTapped = self.originView.startButton.publisher(for: .touchUpInside).map { _ in
        return self.originView.introductionView.introduction.text ?? ""
    }.eraseToAnyPublisher()
    private lazy var skipButtonTapped = self.originView.laterButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var backButtonTapped = self.originView.backButton.publisher(for: .touchUpInside).map { _ in
        OnboardingViewController.pushCount -= 1
        print(OnboardingViewController.pushCount)
    }.eraseToAnyPublisher()
    
    // MARK: - UI Components
    
    private let originView = OnboardingEndingView()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Life Cycles
    
    init(viewModel: OnboardingEndingViewModel) {
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
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
    }
}

// MARK: - Extensions

extension OnboardingEndingViewController {
    private func setUI() {
        self.view.backgroundColor = .donGray1
    }
    
    private func bindViewModel() {
        let input = OnboardingEndingViewModel.Input(
            backButtonTapped: backButtonTapped,
            startButtonTapped: startButtonTapped,
            skipButtonTapped: skipButtonTapped)
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.voidPublisher
            .receive(on: RunLoop.main)
            .sink { value in
                if value == "back" {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let viewController = DontBeTabBarController()
                    print(self.originView.introductionView.introduction.text ?? "") // 텍스트 필드 텍스트 잘 넘어오는지 확인
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            .store(in: self.cancelBag)
    }
}
