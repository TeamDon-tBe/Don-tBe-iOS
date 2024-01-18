//
//  UILabel+.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/8/24.
//

import UIKit

extension UILabel {
    func setTextWithLineHeight(text: String?, lineHeight: CGFloat, alignment: NSTextAlignment){
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
            ]
            
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
            self.textAlignment = alignment
        }
    }
    
    /// 특정 텍스트만 폰트를 다르게 주는 함수
    func asFont(targetString: String, font: UIFont) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttribute(.font, value: font, range: range)
        attributedText = attributedString
    }
    
    func setTextWithLineHeightAndFont(text: String?, lineHeight: CGFloat, targetString: String, font: UIFont) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .font: UIFont.font(.body4)
            ]
            
            let attrString = NSMutableAttributedString(string: text, attributes: attributes)
            
            // 특정 문자열에 대해서만 폰트 변경
            let range = (text as NSString).range(of: targetString)
            attrString.addAttribute(.font, value: font, range: range)
            
            self.attributedText = attrString
        }
    }
    
    class func lineNumber(label: UILabel, labelWidth: CGFloat) -> Int {
        let boundingRect = label.text?.boundingRect(with: .zero, options: [.usesFontLeading], attributes: [.font: label.font as Any], context: nil)
        return Int((boundingRect?.width ?? 0) / labelWidth + 1)
    }
    
    func countCurrentLines() -> Int {
        guard let text = self.text as NSString? else { return 0 }
        guard let font = self.font              else { return 0 }
        
        var attributes = [NSAttributedString.Key: Any]()
        
        // kern을 설정하면 자간 간격이 조정되기 때문에, 크기에 영향을 미칠 수 있습니다.
        if let kernAttribute = self.attributedText?.attributes(at: 0, effectiveRange: nil).first(where: { key, _ in
            return key == .kern
        }) {
            attributes[.kern] = kernAttribute.value
        }
        attributes[.font] = font
        
        // width을 제한한 상태에서 해당 Text의 Height를 구하기 위해 boundingRect 사용
        let labelTextSize = text.boundingRect(
            with: CGSize(width: self.bounds.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        
        // 총 Height에서 한 줄의 Line Height를 나누면 현재 총 Line 수
        return Int(ceil(labelTextSize.height / font.lineHeight))
    } 
}
