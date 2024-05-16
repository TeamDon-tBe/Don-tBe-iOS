//
//  WriteReplyViewController.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/14/24.
//

import UIKit
import Photos
import PhotosUI

import SnapKit

final class WriteReplyViewController: UIViewController {
    
    // MARK: - Properties
    
    static let showUploadToastNotification = Notification.Name("ShowUploadToastNotification")
    
    private var cancelBag = CancelBag()
    private let viewModel: WriteReplyViewModel
    
    private lazy var postButtonTapped =
    writeView.postButton.publisher(for: .touchUpInside).map { _ in
        if self.writeView.linkTextView.text == "" {
            return (WriteReplyImageRequestDTO(
                commentText: self.writeView.writeReplyView.contentTextView.text,
                photoImage: self.writeView.photoImageView.image
            ), self.contentId)
        } else {
            return (WriteReplyImageRequestDTO(
                commentText: self.writeView.writeReplyView.contentTextView.text + "\n" + self.writeView.linkTextView.text,
                photoImage: self.writeView.photoImageView.image
            ), self.contentId)
        }
    }.eraseToAnyPublisher()
    
    var contentId: Int = 0
    var tabBarHeight: CGFloat = 0
    var userNickname: String = ""
    var userProfileImage: UIImage = ImageLiterals.Common.imgProfile
    var userContent: String = ""
    var userContentImage: UIImage?
    
    // MARK: - UI Components
    
    let writeView = WriteReplyView()
    private lazy var cancelReplyPopupVC = CancelReplyPopupViewController()
    
    // MARK: - Life Cycles
    
    init(viewModel: WriteReplyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddTarget()
        setBottomSheet()
        setNavigationBarButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("DismissReplyView"), object: nil, userInfo: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeAreaHeight = view.safeAreaInsets.bottom
        let tabBarHeight: CGFloat = 70.0
        
        self.tabBarHeight = tabBarHeight + safeAreaHeight
    }
}

// MARK: - Extensions

extension WriteReplyViewController {
    private func setUI() {
        writeView.backgroundColor = .donWhite
        title = "답글 달기"
        cancelReplyPopupVC.modalPresentationStyle = .overFullScreen
        
        writeView.writeReplyPostview.postNicknameLabel.text = self.userNickname
        writeView.writeReplyPostview.contentTextLabel.text = self.userContent
        writeView.writeReplyPostview.profileImageView.image = self.userProfileImage
        writeView.writeReplyView.contentTextView.addPlaceholder(self.userNickname + StringLiterals.Write.writeReplyContentPlaceholder, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        if let image = self.userContentImage {
            writeView.writeReplyPostview.photoImageView.image = image
            
            writeView.writeReplyView.snp.remakeConstraints {
                $0.top.equalTo(writeView.writeReplyPostview.photoImageView.snp.bottom).offset(24.adjusted)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(800.adjusted)
            }
        } else {
            writeView.writeReplyView.snp.remakeConstraints {
                $0.top.equalTo(writeView.writeReplyPostview.contentTextLabel.snp.bottom).offset(24.adjusted)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(800.adjusted)
            }
        }
    }
    
    private func setAddTarget() {
        self.writeView.photoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
    }
    
    private func sendData() {
        NotificationCenter.default.post(name: WriteReplyViewController.showUploadToastNotification, object: nil, userInfo: ["showToast": true])
    }
    
    private func bindViewModel() {
        let input = WriteReplyViewModel.Input(postButtonTapped: postButtonTapped)
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.popViewController
            .sink { _ in
                DispatchQueue.main.async {
                    self.popupNavigation()
                    self.sendData()
                }
            }
            .store(in: self.cancelBag)
    }
    
    private func popupNavigation() {
        self.dismiss(animated: true)
    }
    
    private func setBottomSheet() {
        /// 밑으로 내려도 dismiss되지 않는 옵션 값
        isModalInPresentation = true
        
        if let sheet = sheetPresentationController {
            sheet.detents = [.large()]
            sheet.selectedDetentIdentifier = .large
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.prefersGrabberVisible = false
        }
    }
    
    private func setNavigationBarButtonItem() {
        let cancelButton = UIBarButtonItem(
            title: StringLiterals.Write.writeNavigationBarButtonItemTitle,
            style: .plain,
            target: self,
            action: #selector(cancleNavigationBarButtonTapped)
        )
        navigationItem.leftBarButtonItem = cancelButton
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.donGray11,
            .font: UIFont.font(.caption4)
        ]
        cancelButton.setTitleTextAttributes(attributes, for: .normal)
        cancelButton.setTitleTextAttributes(attributes, for: .highlighted)
    }
    
    public func dismissView() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func photoButtonTapped() {
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
    
    private func authSettingOpen() {
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
    
    @objc
    private func cancleNavigationBarButtonTapped() {
        // 텍스트가 비어있는 경우 POP
        if self.writeView.writeReplyView.contentTextView.text == "" {
            popupNavigation()
        } else {
            self.present(self.cancelReplyPopupVC, animated: false, completion: nil)
        }
    }
}

extension WriteReplyViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        guard let selectedImage = results.first else { return }
        
        selectedImage.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
            DispatchQueue.main.async {
                if let image = image as? UIImage {
                    self.writeView.photoImageView.isHidden = false
                    self.writeView.photoImageView.image = image
                } else if let error = error {
                    print(error)
                }
            }
        }
    }
}
