//
//  WriteContentRequestDTO.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/15/24.
//

import Foundation
import UIKit

// MARK: - WriteContentRequestDTO

struct WriteContentRequestDTO: Encodable {
    let contentText: String
}

struct WriteContentImageRequestDTO {
    let contentText: String
    let photoImage: UIImage?
}
