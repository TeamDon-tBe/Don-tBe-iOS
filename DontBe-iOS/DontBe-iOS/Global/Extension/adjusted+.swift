//
//  adjusted+.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/5/24.
//

import UIKit

extension CGFloat {
    var adjusted: CGFloat {
        return adjustedW
    }

    var adjustedW: CGFloat {
        return self * adjustedRatio
    }

    var adjustedH: CGFloat {
        return self * adjustedHRatio
    }

    private var adjustedRatio: CGFloat {
        return UIScreen.main.bounds.width / 375
    }

    private var adjustedHRatio: CGFloat {
        return UIScreen.main.bounds.height / 667
    }
}

extension Int {
    var adjusted: CGFloat {
        return CGFloat(self).adjusted
    }

    var adjustedW: CGFloat {
        return CGFloat(self).adjustedW
    }

    var adjustedH: CGFloat {
        return CGFloat(self).adjustedH
    }
}

extension Double {
    var adjusted: CGFloat {
        return CGFloat(self).adjusted
    }

    var adjustedW: CGFloat {
        return CGFloat(self).adjustedW
    }

    var adjustedH: CGFloat {
        return CGFloat(self).adjustedH
    }
}
