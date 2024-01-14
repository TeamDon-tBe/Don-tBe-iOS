//
//  BaseResponse.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/14/24.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: T?
}
