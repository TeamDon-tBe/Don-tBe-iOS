//
//  UIColor+.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/6/24.
//

import UIKit

extension UIColor {
    static var donPrimary: UIColor {
        return UIColor(hex: "#7AEBA8")
    }
    
    static var donSecondary: UIColor {
        return UIColor(hex: "#60D5A4")
    }
    
    static var donPale: UIColor {
        return UIColor(hex: "#ECF6F3")
    }
    
    static var donWhite: UIColor {
        return UIColor(hex: "#FCFCFD")
    }
    
    static var donBlack: UIColor {
        return UIColor(hex: "#0E0E0E")
    }
    
    static var donGray1: UIColor {
        return UIColor(hex: "#F6F6F7")
    }
    
    static var donGray2: UIColor {
        return UIColor(hex: "#EBEBEE")
    }
    
    static var donGray3: UIColor {
        return UIColor(hex: "#E1E1E4")
    }
    
    static var donGray4: UIColor {
        return UIColor(hex: "#D7D7DA")
    }
    
    static var donGray5: UIColor {
        return UIColor(hex: "#CDCDD0")
    }
    
    static var donGray6: UIColor {
        return UIColor(hex: "#C2C2C5")
    }
    
    static var donGray7: UIColor {
        return UIColor(hex: "#B5B5B8")
    }
    
    static var donGray8: UIColor {
        return UIColor(hex: "#A3A3A6")
    }
    
    static var donGray9: UIColor {
        return UIColor(hex: "#8F8F92")
    }
    
    static var donGray10: UIColor {
        return UIColor(hex: "#717174")
    }
    
    static var donGray11: UIColor {
        return UIColor(hex: "#5D5D60")
    }
    
    static var donGray12: UIColor {
        return UIColor(hex: "#49494C")
    }
    
    static var donError: UIColor {
        return UIColor(hex: "#FF5E5E")
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
