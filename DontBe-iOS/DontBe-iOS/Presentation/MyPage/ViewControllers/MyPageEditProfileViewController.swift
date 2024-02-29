//
//  MyPageEditProfileViewController.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/12/24.
//

import Combine
import UIKit
import Photos
import PhotosUI

import SnapKit

final class MyPageEditProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    static let showWriteToastNotification = Notification.Name("ShowWriteToastNotification")
    
    private var cancelBag = CancelBag()
    private let viewModel: MyPageProfileViewModel
    
    private lazy var backButtonTapped = navigationBackButton.publisher(for: .touchUpInside).map { _ in }.eraseToAnyPublisher()
    private lazy var duplicationCheckButtonTapped = self.nicknameEditView.duplicationCheckButton.publisher(for: .touchUpInside).map { _ in
        return self.nicknameEditView.nickNameTextField.text ?? ""
    }.eraseToAnyPublisher()
    private lazy var postButtonTapped = self.introductionEditView.postActiveButton.publisher(for: .touchUpInside).map { _ in
        return EditUserProfileRequestDTO(nickname: self.nicknameEditView.nickNameTextField.text ?? "",
                                         is_alarm_allowed: true,
                                         member_intro: self.introductionEditView.contentTextView.text ?? "",
                                         profile_image: self.nicknameEditView.profileImage.image ?? ImageLiterals.Common.imgProfile)
    }.eraseToAnyPublisher()
    
    var memberId: Int = 0
    var isTrue: Bool = true
    var nickname: String = ""
    var introText: String = ""

    // MARK: - UI Components
    
    private let navigationBackButton = BackButton()
    let nicknameEditView = MyPageNicknameEditView()
    let introductionEditView = MyPageIntroductionEditView()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        setAddTarget()
    }
    
    init(viewModel: MyPageProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        
        let backButton = UIBarButtonItem.backButton(target: self, action: #selector(navBackButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.nicknameEditView.nickNameTextField.text = nickname
        self.nicknameEditView.numOfLetters.text = "(\(nickname.count)/12)"
        
        if introText == "" {
            self.introductionEditView.contentTextView.addPlaceholder(StringLiterals.MyPage.myPageEditIntroductionPlease, padding: UIEdgeInsets(top: 14.adjusted, left: 14.adjusted, bottom: 14.adjusted, right: 14.adjusted))
        } else {
            self.introductionEditView.contentTextView.text = introText
            self.introductionEditView.numOfLetters.text = "(\(introText.count)/50)"
        }
        setNotification()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }
}

// MARK: - Extensions

extension MyPageEditProfileViewController {
    private func setUI() {
        self.title = StringLiterals.MyPage.MyPageEditNavigationTitle
        self.view.backgroundColor = .donWhite
        self.title = StringLiterals.MyPage.MyPageEditNavigationTitle
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.donBlack]
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func setHierarchy() {
        self.view.addSubviews(nicknameEditView,
                              introductionEditView)
    }
    
    private func setLayout() {
        nicknameEditView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(323.adjusted)
        }
        
        introductionEditView.snp.makeConstraints {
            $0.top.equalTo(nicknameEditView.duplicationCheckDescription.snp.bottom).offset(16.adjustedH)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTisEmpty), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    private func setAddTarget() {
        self.nicknameEditView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        let input = MyPageProfileViewModel.Input(viewWillAppear: Just((self.memberId)).eraseToAnyPublisher(),
                                                 backButtonTapped: backButtonTapped,
                                                 duplicationCheckButtonTapped: duplicationCheckButtonTapped,
                                                 finishButtonTapped: postButtonTapped)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.getProfileData
            .receive(on: RunLoop.main)
            .sink { data in
                DispatchQueue.main.async {
                    self.nicknameEditView.profileImage.load(url: data)
                }
            }
            .store(in: self.cancelBag)
        
        output.popViewController
            .receive(on: RunLoop.main)
            .sink { _ in
                self.navigationController?.popViewController(animated: false)
            }
            .store(in: self.cancelBag)
        
        output.isEnable
            .receive(on: RunLoop.main)
            .sink { isEnable in
                print("\(isEnable)")
                self.nicknameEditView.nickNameTextField.resignFirstResponder()
                self.introductionEditView.postActiveButton.isHidden = !isEnable
                if isEnable {
                    // 닉네임 사용 가능
                    self.nicknameEditView.duplicationCheckDescription.text = StringLiterals.Join.duplicationPass
                    self.nicknameEditView.duplicationCheckDescription.textColor = .donSecondary
                    self.introductionEditView.postButton.isHidden = true
                    self.introductionEditView.postActiveButton.isHidden = false
                } else {
                    // 닉네임 중복
                    self.nicknameEditView.duplicationCheckDescription.text = StringLiterals.Join.duplicationNotPass
                    self.nicknameEditView.duplicationCheckDescription.textColor = .donError
                    self.introductionEditView.postButton.isHidden = false
                    self.introductionEditView.postActiveButton.isHidden = true
                }
            }
            .store(in: self.cancelBag)
    }
    
    private func presentPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // 이미지만 필터링
        configuration.selectionLimit = 1 // 선택 제한
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc
    private func textFieldTisEmpty() {
        self.introductionEditView.postButton.isHidden = false
        self.introductionEditView.postActiveButton.isHidden = true
    }
    
    @objc
    private func navBackButtonTapped() {
        self.navigationController?.popViewController(animated: false)
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

extension MyPageEditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        guard let selectedImage = results.first else { return }
        
        selectedImage.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
            DispatchQueue.main.async {
                if let image = image as? UIImage {
                    self.nicknameEditView.profileImage.image = image
                } else if let error = error {
                    print(error)
                }
            }
        }
    }
}
