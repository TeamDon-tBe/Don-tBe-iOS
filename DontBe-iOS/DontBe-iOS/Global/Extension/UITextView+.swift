//
//  UITextView+.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/8/24.
//

import UIKit

import SnapKit

extension UITextView {
    func addPlaceholder(_ placeholder: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = .donGray8
        placeholderLabel.textAlignment = .left
        placeholderLabel.font = self.font
        
        self.addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
        updatePlaceholderVisibility(placeholderLabel)
    }
    
    @objc private func textViewTextDidChange() {
        for subview in self.subviews {
            if let placeholderLabel = subview as? UILabel, placeholderLabel.textColor == .donGray8 {
                updatePlaceholderVisibility(placeholderLabel)
            }
        }
    }
    
    private func updatePlaceholderVisibility(_ placeholderLabel: UILabel) {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
}
