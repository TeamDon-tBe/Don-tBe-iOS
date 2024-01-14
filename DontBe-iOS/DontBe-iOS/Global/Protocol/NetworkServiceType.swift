//
//  NetworkServiceType.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/14/24.
//

import Foundation

protocol NetworkServiceType {
    func donMakeRequest(type: HttpMethod,
                        baseURL: String,
                        accessToken: String,
                        body: Encodable,
                        pathVariables: [String: String]) -> URLRequest
    
    func donNetwork<T: Decodable>(type: HttpMethod,
                                  baseURL: String,
                                  accessToken: String,
                                  body: Encodable,
                                  pathVariables: [String: String]) async throws -> T?
}

