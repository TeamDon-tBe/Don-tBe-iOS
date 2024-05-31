//
//  DontBePhotoDetailView.swift
//  DontBe-iOS
//
//  Created by 변상우 on 5/14/24.
//

import UIKit

import SnapKit

final class DontBePhotoDetailView: UIView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = .donBlack.withAlphaComponent(0.6)
        return view
    }()
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4.adjusted
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let removePhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Write.btnCloseLink, for: .normal)
        return button
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension DontBePhotoDetailView {
    
    private func setHierarchy() {
        self.addSubview(dimView)
        dimView.addSubview(photoImageView)
        photoImageView.addSubview(removePhotoButton)
    }
    
    private func setLayout() {
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        photoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(327.adjusted)
            $0.height.equalTo(434.adjusted)
        }
        
        removePhotoButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(8.adjusted)
            $0.size.equalTo(44)
        }
    }
}
