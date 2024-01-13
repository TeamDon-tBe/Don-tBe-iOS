//
//  NetworkError.swift
//  DontBe
//
//  Created by 변상우 on 12/26/23.
//

import UIKit

enum NetworkError: Int, Error, CustomStringConvertible {
    var description: String { self.errorDescription }
    case badRequestError = 400
    case unautohorizedError = 401
    case notFoundError = 404
    case internalServerError = 500
    case unknownError
    
    var errorDescription: String {
        switch self {
        case .badRequestError: return "BAD_REQUEST_ERROR"
        case .unautohorizedError: return "UNAUTHORIZED_ERROR"
        case .notFoundError: return "NOT_FOUND_ERROR"
        case .internalServerError: return "SERVER_ERROR"
        case .unknownError: return "UNKNOWN_ERROR"
        }
    }
}
