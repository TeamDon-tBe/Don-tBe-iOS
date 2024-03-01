//
//  MyPageSignOutViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 2/12/24.
//

import UIKit

class MyPageSignOutViewController: UIViewController {

    // MARK: - Properties
    
    private var cancelBag = CancelBag()
    private let myPageSignOutReasonViewModel: MyPageSignOutReasonViewModel
    
    private lazy var firstReason = self.myView.firstReasonView.radioButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var secondReason = self.myView.secondReasonView.radioButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var thirdReason = self.myView.thirdReasonView.radioButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var fourthReason = self.myView.fourthReasonView.radioButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var fifthReason = self.myView.fifthReasonView.radioButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var sixthReason = self.myView.sixthReasonView.radioButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var seventhReason = self.myView.seventhReasonView.radioButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    
    var signOutReason: String = ""
    
    // MARK: - UI Components
    
    private let myView = MyPageSignOutView()
    private var navigationBackButton = BackButton()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = myView
    }
    
    init(viewModel: MyPageSignOutReasonViewModel) {
        self.myPageSignOutReasonViewModel = viewModel
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
        setAddTarget()
        bindViewModel()
    }
}

// MARK: - Extensions

extension MyPageSignOutViewController {
    private func setUI() {
        self.title = StringLiterals.MyPage.MyPageSignOutNavigationTitle
        self.view.backgroundColor = .donWhite
        
        self.navigationController?.navigationBar.backgroundColor = .donWhite
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        self.navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem.backButton(target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setHierarchy() {
        
    }
    
    private func setLayout() {
        
    }
    
    private func setDelegate() {
        
    }
    
    private func setAddTarget() {
        self.myView.continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        let input = MyPageSignOutReasonViewModel.Input(
            firstReasonButtonTapped: firstReason,
            secondReasonButtonTapped: secondReason,
            thirdReasonButtonTapped: thirdReason,
            fourthReasonButtonTapped: fourthReason,
            fifthReasonButtonTapped: fifthReason,
            sixthReasonButtonTapped: sixthReason,
            seventhReasonButtonTapped: seventhReason)
        
        let output = myPageSignOutReasonViewModel.transform(from: input, cancelBag: cancelBag)
        
        output.clickedButtonState
            .sink { [weak self] index in
                guard let self = self else { return }
                let radioSelectedButtonImage = ImageLiterals.TransparencyInfo.btnRadioSelected
                let radioButtonImage = ImageLiterals.TransparencyInfo.btnRadio
                
                self.myView.continueButton.setTitleColor(.donWhite, for: .normal)
                self.myView.continueButton.backgroundColor = .donBlack
                self.myView.continueButton.isEnabled = true
                
                switch index {
                case 1:
                    self.myView.firstReasonView.radioButton.setImage(radioSelectedButtonImage, for: .normal)
                    self.myView.secondReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.thirdReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.fourthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.fifthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.sixthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    signOutReason = self.myView.firstReasonView.reasonLabel.text ?? ""
                case 2:
                    self.myView.firstReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.secondReasonView.radioButton.setImage(radioSelectedButtonImage, for: .normal)
                    self.myView.thirdReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.fourthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.fifthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.sixthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    signOutReason = self.myView.secondReasonView.reasonLabel.text ?? ""
                case 3:
                    self.myView.firstReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.secondReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.thirdReasonView.radioButton.setImage(radioSelectedButtonImage, for: .normal)
                    self.myView.fourthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.fifthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.sixthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    signOutReason = self.myView.thirdReasonView.reasonLabel.text ?? ""
                case 4:
                    self.myView.firstReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.secondReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.thirdReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.fourthReasonView.radioButton.setImage(radioSelectedButtonImage, for: .normal)
                    self.myView.fifthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.sixthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    signOutReason = self.myView.fourthReasonView.reasonLabel.text ?? ""
                case 5:
                    self.myView.firstReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.secondReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.thirdReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.fourthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.fifthReasonView.radioButton.setImage(radioSelectedButtonImage, for: .normal)
                    self.myView.sixthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    signOutReason = self.myView.fifthReasonView.reasonLabel.text ?? ""
                case 6:
                    self.myView.firstReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.secondReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.thirdReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.fourthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.fifthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.sixthReasonView.radioButton.setImage(radioSelectedButtonImage, for: .normal)
                    signOutReason = self.myView.sixthReasonView.reasonLabel.text ?? ""
                    
                case 7:
                    self.myView.firstReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.secondReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.thirdReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.fourthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.fifthReasonView.radioButton.setImage(radioButtonImage, for: .normal)
                    self.myView.sixthReasonView.radioButton.setImage(radioSelectedButtonImage, for: .normal)
                    signOutReason = self.myView.seventhReasonView.reasonLabel.text ?? ""
                default:
                    break
                }
            }
            .store(in: self.cancelBag)
    }
    
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func continueButtonTapped() {
        let vc = MyPageSignOutConfirmViewController(viewModel: MyPageAccountInfoViewModel(networkProvider: NetworkService()))
        vc.signOutReason = self.signOutReason
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
