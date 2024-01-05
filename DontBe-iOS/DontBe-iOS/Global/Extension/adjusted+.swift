//
//  adjusted+.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/5/24.
//

import UIKit

extension CGFloat {
    var adjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 375
        return self * ratio
    }
    
    var adjustedH: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 667
        return self * ratio
    }
}

extension Int {
    var adjusted: Int {
        let ratio: Int = Int(UIScreen.main.bounds.width / 375)
        return self * ratio
    }
    
    var adjustedH: Int {
        let ratio: Int = Int(UIScreen.main.bounds.height / 667)
        return self * ratio
    }
}

extension Double {
    var adjusted: Double {
        let ratio: Double = Double(UIScreen.main.bounds.width / 375)
        return self * ratio
    }
    
    var adjustedH: Double {
        let ratio: Double = Double(UIScreen.main.bounds.height / 667)
        return self * ratio
    }
}
