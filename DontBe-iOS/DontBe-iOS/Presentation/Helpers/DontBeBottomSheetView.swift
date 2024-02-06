//
//  DontBeBottomSheetView.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/12/24.
//

import UIKit

import SnapKit

final class DontBeBottomSheetView: UIView {
    
    // MARK: - Properties
    
    var initialPosition: CGPoint = CGPoint(x: 0, y: 0)
    var isUser: Bool = true
    
    // MARK: - UI Components
    
    let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = .donBlack.withAlphaComponent(0.6)
        return view
    }()
    
    let bottomsheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .donWhite
        view.layer.cornerRadius = 8.adjusted
        return view
    }()
    
    private let dragIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .donGray5
        view.layer.cornerRadius = 2.adjusted
        return view
    }()
    
    let deleteButton = DontBeBottomSheetButton(title: StringLiterals.BottomSheet.deleteLabel,
                                               image: ImageLiterals.BottomSheet.deleteIcon)
    
    let warnButton = DontBeBottomSheetButton(title: StringLiterals.BottomSheet.warnLabel,
                                             image: ImageLiterals.BottomSheet.warnIcon)
    
    let profileEditButton = DontBeBottomSheetButton(title: StringLiterals.BottomSheet.profileEdit)
    
    let accountInfoButton = DontBeBottomSheetButton(title: StringLiterals.BottomSheet.accountInfo)
    
    let feedbackButton = DontBeBottomSheetButton(title: StringLiterals.BottomSheet.feedback)
    
    let customerCenterButton = DontBeBottomSheetButton(title: StringLiterals.BottomSheet.customerCenter)
    
    let logoutButton = DontBeBottomSheetButton(title: StringLiterals.BottomSheet.logout)
    
    // MARK: - Life Cycles
    
    init(singleButtonImage: UIImage) {
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
    }
    
    init(profileEditImage: UIImage, accountInfoImage: UIImage, feedbackImage: UIImage, customerCenterImage: UIImage, logoutImage: UIImage) {
        super.init(frame: .zero)
        
        setMultiButtonHierarchy()
        setMultiButtonLayout()
        setAddTarget()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension DontBeBottomSheetView {
    private func setUI() {
        
    }
    
    private func setHierarchy() {
        self.addSubviews(dimView,
                         bottomsheetView)
        bottomsheetView.addSubviews(dragIndicatorView,
                                    warnButton,
                                    deleteButton)
    }
    
    private func setLayout() {
        bottomsheetView.snp.makeConstraints {
            $0.height.equalTo(155.adjusted)
        }
        
        dragIndicatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(50.adjusted)
            $0.height.equalTo(2.adjusted)
            $0.top.equalTo(19.adjusted)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15.adjusted)
            $0.top.equalTo(dragIndicatorView).offset(30.adjusted)
        }
        
        warnButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15.adjusted)
            $0.top.equalTo(dragIndicatorView).offset(30.adjusted)
        }
    }
    
    private func setAddTarget() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlepanGesture))
        bottomsheetView.addGestureRecognizer(panGesture)
    }
    
    private func setMultiButtonHierarchy() {
        self.addSubviews(dimView,
                         bottomsheetView)
        bottomsheetView.addSubviews(dragIndicatorView,
                                    profileEditButton,
                                    accountInfoButton,
                                    feedbackButton,
                                    customerCenterButton,
                                    logoutButton)
    }
    
    private func setMultiButtonLayout() {
        bottomsheetView.snp.makeConstraints {
            $0.height.equalTo(434.adjusted)
        }
        
        dragIndicatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(50.adjusted)
            $0.height.equalTo(2.adjusted)
            $0.top.equalTo(19.adjusted)
        }
        
        profileEditButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15.adjusted)
            $0.top.equalTo(dragIndicatorView).offset(30.adjusted)
        }
        
        accountInfoButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15.adjusted)
            $0.top.equalTo(profileEditButton.snp.bottom).offset(10.adjusted)
        }
        
        feedbackButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15.adjusted)
            $0.top.equalTo(accountInfoButton.snp.bottom).offset(10.adjusted)
        }
        
        customerCenterButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15.adjusted)
            $0.top.equalTo(feedbackButton.snp.bottom).offset(10.adjusted)
        }
        
        logoutButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15.adjusted)
            $0.top.equalTo(customerCenterButton.snp.bottom).offset(10.adjusted)
        }
    }
    
    func showSettings() {
        if let window = UIApplication.shared.keyWindowInConnectedScenes {
            dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubviews(dimView, bottomsheetView)
            
            dimView.frame = window.frame
            dimView.alpha = 0
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.dimView.alpha = 1
                
                self.bottomsheetView.snp.makeConstraints {
                    $0.centerX.equalToSuperview()
                    $0.bottom.equalTo(window.snp.bottom)
                    $0.leading.trailing.equalToSuperview()
                }
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss() {
        if UIApplication.shared.keyWindowInConnectedScenes != nil {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.dimView.alpha = 0
                if let window = UIApplication.shared.keyWindowInConnectedScenes {
                    self.bottomsheetView.frame = CGRect(x: 0, y: window.frame.height, width: self.bottomsheetView.frame.width, height: self.bottomsheetView.frame.height)
                }
            })
            dimView.removeFromSuperview()
            bottomsheetView.removeFromSuperview()
        }
            
    }
    
    @objc private func handlepanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .began:
            initialPosition = self.center
        case .changed:
            self.center = CGPoint(x: initialPosition.x, y: initialPosition.y + translation.y)
        case .ended:
            if self.frame.origin.y < 512.adjusted {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.dimView.alpha = 0
                    if let window = UIApplication.shared.keyWindowInConnectedScenes {
                        self.bottomsheetView.frame = CGRect(x: 0, y: window.frame.height, width: self.bottomsheetView.frame.width, height: self.bottomsheetView.frame.height)
                    }
                })
                dimView.removeFromSuperview()
                bottomsheetView.removeFromSuperview()
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.frame.origin = self.initialPosition
                })
            }
        default:
            break
        }
    }
}
