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
    static var pushCount: Int = 0
    private let dummy = OnboardingDummy.dummy()
    
    // MARK: - UI Components
    
    private let progressImage: UIImageView = {
        let progress = UIImageView()
        progress.image = ImageLiterals.Onboarding.progressbar1
        return progress
    }()
    
    private let titleImage: UIImageView = {
        let title = UIImageView()
        title.image = ImageLiterals.Onboarding.imgOneTitle
        title.contentMode = .scaleAspectFit
        return title
    }()
    
    private let mainImage: UIImageView = {
        let mainImage = UIImageView()
        mainImage.image = ImageLiterals.Onboarding.imgOne
        mainImage.contentMode = .scaleAspectFit
        return mainImage
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Common.btnBack, for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let nextButton = CustomButton(title: "다음으로", backColor: .donBlack, titleColor: .donWhite)
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
        self.view.addSubviews(backButton,
                              progressImage,
                              titleImage,
                              mainImage,
                              nextButton,
                              skipButton)
    }
    
    private func setLayout() {
        let statusBarHeight = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .statusBarManager?
            .statusBarFrame.height ?? 20
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(statusBarHeight + 38.adjusted)
            $0.leading.equalToSuperview().inset(23.adjusted)
            $0.size.equalTo(24.adjusted)
        }
        
        progressImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(statusBarHeight + 46.adjusted)
            $0.width.equalTo(48.adjusted)
            $0.height.equalTo(6.adjusted)
        }
        
        titleImage.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(91.adjusted)
            $0.top.equalToSuperview().inset(statusBarHeight + 90.adjusted)
            $0.height.equalTo(72.adjusted)
        }
        
        mainImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(360.adjusted)
            $0.height.equalTo(340.adjusted)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(91.adjusted)
            $0.centerX.equalToSuperview()
        }
        
        skipButton.snp.makeConstraints {
            $0.top.equalTo(nextButton.snp.bottom).offset(12.adjusted)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        let input = OnboardingViewModel.Input(nextButtonTapped: nextButtonTapped)
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.voidPublisher
            .sink { _ in
                OnboardingViewController.pushCount = OnboardingViewController.pushCount + 1
                if OnboardingViewController.pushCount < 3 {
                    let viewController = OnboardingViewController(viewModel: OnboardingViewModel())
                    self.setOnboardingView(viewController: viewController)
                    self.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    let viewController = OnboardingEndingViewController()
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            .store(in: self.cancelBag)
    }
    
    private func setOnboardingView(viewController: OnboardingViewController) {
        viewController.backButton.isHidden = false
        viewController.progressImage.image = self.dummy[OnboardingViewController.pushCount].progress
        viewController.titleImage.image = self.dummy[OnboardingViewController.pushCount].titleImage
        viewController.mainImage.image = self.dummy[OnboardingViewController.pushCount].mainImage
    }
}
