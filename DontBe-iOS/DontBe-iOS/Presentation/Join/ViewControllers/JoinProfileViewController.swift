//
//  JoinProfileViewController.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/11/24.
//

import UIKit
import Photos
import PhotosUI

import SnapKit

final class JoinProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private var cancelBag = CancelBag()
    private let viewModel: JoinProfileViewModel
    
    private lazy var backButtonTapped = navigationBackButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var duplicationCheckButtonTapped = self.originView.duplicationCheckButton.publisher(for: .touchUpInside).map { _ in
        return self.originView.nickNameTextField.text ?? ""
    }.eraseToAnyPublisher()
    private lazy var finishButtonTapped = self.originView.finishActiveButton.publisher(for: .touchUpInside).map { _ in
        return EditUserProfileRequestDTO(nickname: self.originView.nickNameTextField.text ?? "",
                                         is_alarm_allowed: true,
                                         member_intro: "",
                                         profile_image: self.originView.profileImage.image ?? ImageLiterals.Common.imgProfile)
    }.eraseToAnyPublisher()
    
    
    // MARK: - UI Components
    
    private let navigationBackButton = BackButton()
    private let originView = JoinProfileView()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
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
        setAddTarget()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        setDelegate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }
}

// MARK: - Extensions

extension JoinProfileViewController {
    private func setUI() {
        self.view.backgroundColor = .donGray1
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
    
    private func setAddTarget() {
        self.originView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    private func setDelegate() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTisEmpty), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    private func bindViewModel() {
        let input = JoinProfileViewModel.Input(backButtonTapped: backButtonTapped, duplicationCheckButtonTapped: duplicationCheckButtonTapped, finishButtonTapped: finishButtonTapped)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.pushOrPopViewController
            .receive(on: RunLoop.main)
            .sink { value in
                if value == 0 {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let viewContoller = OnboardingViewController()
                    viewContoller.originView.isFirstUser = true
                    self.navigationBackButton.removeFromSuperview()
                    self.navigationController?.pushViewController(viewContoller, animated: true)
                }
            }
            .store(in: self.cancelBag)
        
        output.isEnable
            .receive(on: RunLoop.main)
            .sink { isEnable in
                self.originView.nickNameTextField.resignFirstResponder()
                self.originView.finishActiveButton.isHidden = !isEnable
                if isEnable {
                    self.originView.duplicationCheckDescription.text = StringLiterals.Join.duplicationPass
                    self.originView.duplicationCheckDescription.textColor = .donSecondary
                } else {
                    self.originView.duplicationCheckDescription.text = StringLiterals.Join.duplicationNotPass
                    self.originView.duplicationCheckDescription.textColor = .donError
                }
            }
            .store(in: self.cancelBag)
    }
    
    @objc
    private func textFieldTisEmpty() {
        self.originView.finishActiveButton.isHidden = true
        self.originView.finishButton.isHidden = false
        self.originView.duplicationCheckDescription.text = StringLiterals.Join.duplicationCheckDescription
        self.originView.duplicationCheckDescription.textColor = .donGray8
    }
    
    @objc
    private func plusButtonTapped() {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        
        switch status {
        case .authorized, .limited:
            presentPicker()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self?.presentPicker()
                    }
                }
            }
        case .denied, .restricted:
            authSettingOpen()
        default:
            break
        }
    }
    
    private func presentPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // 이미지만 필터링
        configuration.selectionLimit = 1 // 선택 제한
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func authSettingOpen() {
        let message = StringLiterals.Camera.photoNoAuth
        
        let alert = UIAlertController(title: "설정", message: message, preferredStyle: .alert)
        
        let cancle = UIAlertAction(title: "닫기", style: .default)
        
        let confirm = UIAlertAction(title: "권한설정하기", style: .default) { (UIAlertAction) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        
        alert.addAction(cancle)
        alert.addAction(confirm)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension JoinProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        guard let selectedImage = results.first else { return }
        
        selectedImage.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
            DispatchQueue.main.async {
                if let image = image as? UIImage {
                    self.originView.profileImage.image = image
                    self.originView.profileImage.contentMode = .scaleAspectFill
                    self.originView.profileImage.layer.cornerRadius = self.originView.profileImage.frame.size.width / 2
                    self.originView.profileImage.clipsToBounds = true
                } else if let error = error {
                    print(error)
                }
            }
        }
    }
}
