//
//  WriteReplyRequestDTO.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/17/24.
//

import Foundation
import UIKit

struct WriteReplyRequestDTO: Encodable {
    let commentText: String
    let notificationTriggerType: String
}

struct WriteReplyImageRequestDTO {
    let commentText: String
    let photoImage: UIImage?
}
