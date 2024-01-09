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
    private lazy var startButtonTapped = self.startButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var backButtonTapped = self.backButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()

    // MARK: - UI Components
    
    private let progressImage: UIImageView = {
        let progress = UIImageView()
        progress.image = ImageLiterals.Onboarding.progressbar4
        return progress
    }()
    
    private let titleImage: UIImageView = {
        let title = UIImageView()
        title.image = ImageLiterals.Onboarding.imgFourthTitle
        title.contentMode = .scaleAspectFit
        return title
    }()
    
    private let profileImage: UIImageView = {
        let profile = UIImageView()
        profile.image = ImageLiterals.Onboarding.imgProfile
        return profile
    }()

    private let introductionView = OnboardingEndingView()
    
    private let backButton = BackButton()
    private let startButton = CustomButton(title: "시작하기", backColor: .donPrimary, titleColor: .donBlack)
    
    private let skipButton = CustomButton(title: "건너뛰기", backColor: .clear, titleColor: .donGray7)
    
    // MARK: - Life Cycles
    
    init(viewModel: OnboardingEndingViewModel) {
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

extension OnboardingEndingViewController {
    private func setUI() {
        self.view.backgroundColor = .donGray1
    }
    
    private func setHierarchy() {
        self.view.addSubviews(backButton,
                              progressImage,
                              titleImage,
                              profileImage,
                              introductionView,
                              startButton,
                              skipButton)
        self.view.bringSubviewToFront(profileImage)
    }
    
    private func setLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(statusBarHeight + 38.adjusted)
            $0.leading.equalToSuperview().inset(23.adjusted)
        }
        
        progressImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(statusBarHeight + 46.adjusted)
            $0.width.equalTo(48.adjusted)
            $0.height.equalTo(6.adjusted)
        }
        
        titleImage.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(91.adjusted)
            $0.top.equalToSuperview().inset(statusBarHeight + 90.adjustedH)
            $0.height.equalTo(72.adjusted)
        }
        
        profileImage.snp.makeConstraints {
            $0.size.equalTo(100.adjusted)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(statusBarHeight + 201.adjustedH)
        }
        
        introductionView.snp.makeConstraints {
            $0.width.equalTo(320.adjusted)
            $0.height.equalTo(211.adjusted)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImage).offset(50.adjusted)
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(91.adjusted)
            $0.centerX.equalToSuperview()
        }
        
        skipButton.snp.makeConstraints {
            $0.top.equalTo(startButton.snp.bottom).offset(12.adjusted)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        let input = OnboardingEndingViewModel.Input(startButtonTapped: startButtonTapped, backButtonTapped: backButtonTapped)
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.voidPublisher
//            .receive(on: RunLoop.main)
            .sink { value in
                if value == "start" {
                    let viewController = OnboardingViewController()
                    print(self.introductionView.introduction.text ?? "") // 텍스트 필드 텍스트 잘 넘어오는지 확인
                    self.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
            .store(in: self.cancelBag)
    }
}
