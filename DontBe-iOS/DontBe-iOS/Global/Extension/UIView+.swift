//
//  UIView+.swift
//  DontBe
//
//  Created by 변상우 on 12/26/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
    
    func makeDivisionLine() -> UIView {
        let divisionLine = UIView()
        divisionLine.backgroundColor = .donGray2
        return divisionLine
    }
    
    func isValidInput(_ input: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z_0-9]+$", options: .caseInsensitive)
        let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
        return matches.count > 0
    }
}

