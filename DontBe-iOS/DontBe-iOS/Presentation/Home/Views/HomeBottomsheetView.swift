//
//  HomeBottomsheetView.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/11/24.
//

import UIKit

import SnapKit

final class HomeBottomsheetView: UIView {
    
    // MARK: - Properties
    
    var initialPosition: CGPoint = CGPoint(x: 0, y: 0)
    
    // MARK: - UI Components
    
    private let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    private let bottomsheetView: UIView = {
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
    
    private let userActionButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Posting.btnDelete, for: .normal)
        return button
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
        setRegisterCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension HomeBottomsheetView {
    private func setUI() {
    }
    
    private func setHierarchy() {
        bottomsheetView.addSubviews(dragIndicatorView, userActionButton)
    }
    
    private func setLayout() {
        dragIndicatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(2)
            $0.top.equalTo(19)
        }
        
        userActionButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(344)
            $0.height.equalTo(60)
            $0.top.equalTo(dragIndicatorView).offset(30)
        }
    }
    
    private func setAddTarget() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlepanGesture))
        bottomsheetView.addGestureRecognizer(panGesture)
    }
    
    private func setRegisterCell() {
        
    }
    
    private func setDataBind() {
        
    }
    
    func showSettings() {
        if let window = UIApplication.shared.keyWindowInConnectedScenes {
            dimView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
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
                    $0.height.equalTo(155)
                }
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.dimView.alpha = 0
            if let window = UIApplication.shared.keyWindowInConnectedScenes {
                self.bottomsheetView.frame = CGRect(x: 0, y: window.frame.height, width: self.bottomsheetView.frame.width, height: self.bottomsheetView.frame.height)
            }
        })
    }
    
    @objc private func handlepanGesture(_ gesture: UIPanGestureRecognizer) {
        if let window = UIApplication.shared.keyWindowInConnectedScenes {
            let translation = gesture.translation(in: self)
            
            switch gesture.state {
            case .began:
                initialPosition = self.center
            case .changed:
                self.center = CGPoint(x: initialPosition.x, y: initialPosition.y + translation.y)
            case .ended:
                if self.frame.origin.y < 512 {
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.dimView.alpha = 0
                        if let window = UIApplication.shared.keyWindowInConnectedScenes {
                            self.bottomsheetView.frame = CGRect(x: 0, y: window.frame.height, width: self.bottomsheetView.frame.width, height: self.bottomsheetView.frame.height)
                        }
                    })
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
}
