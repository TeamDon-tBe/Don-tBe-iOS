//
//  TransparencyInfoDummy.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/11/24.
//

import UIKit

struct TransparencyInfoDummy {
    let infoImage: UIImage
    let title: String
    let content: String
}

extension TransparencyInfoDummy {
    static func dummy() -> [TransparencyInfoDummy] {
        return [
            TransparencyInfoDummy(
                infoImage: ImageLiterals.TransparencyInfo.imgTransparencyInfo1,
                title: StringLiterals.TransparencyInfo.title1,
                content: StringLiterals.TransparencyInfo.content1
            ),
            TransparencyInfoDummy(
                infoImage: ImageLiterals.TransparencyInfo.imgTransparencyInfo2,
                title: StringLiterals.TransparencyInfo.title2,
                content: StringLiterals.TransparencyInfo.content2
            ),
            TransparencyInfoDummy(
                infoImage: ImageLiterals.TransparencyInfo.imgTransparencyInfo3,
                title: StringLiterals.TransparencyInfo.title3,
                content: StringLiterals.TransparencyInfo.content3
            ),
            TransparencyInfoDummy(
                infoImage: ImageLiterals.TransparencyInfo.imgTransparencyInfo4,
                title: StringLiterals.TransparencyInfo.title4,
                content: StringLiterals.TransparencyInfo.content4
            ),
            TransparencyInfoDummy(
                infoImage: ImageLiterals.TransparencyInfo.imgTransparencyInfo5,
                title: StringLiterals.TransparencyInfo.title5,
                content: StringLiterals.TransparencyInfo.content5
            )
        ]
    }
}

