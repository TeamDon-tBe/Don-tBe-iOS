//
//  KakaoLoginService.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/14/24.
//

import Foundation

final class NetworkService: NetworkServiceType {
    func donMakeRequest(type: HttpMethod,
                        baseURL: String,
                        accessToken: String,
                        body: Encodable,
                        pathVariables: [String: String]) -> URLRequest {
        var urlComponents = URLComponents(string: baseURL)
        
        // Path Variable 추가
        for (key, value) in pathVariables {
            let pathVariableItem = URLQueryItem(name: key, value: value)
            urlComponents?.queryItems = [pathVariableItem]
        }
        
        // 기존의 URL이 존재하지 않으면 fatalError
        guard let url = urlComponents?.url else {
            fatalError("Failed to create URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = type.method
        
        let header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]
        
        header.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        // 리퀘스트 바디 설정 (구조체)
        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        } catch {
            print("Failed to encode request body: \(error)")
        }
        
        return request
    }

    
    func donNetwork<T: Decodable>(type: HttpMethod,
                                  baseURL: String,
                                  accessToken: String,
                                  body: Encodable,
                                  pathVariables: [String: String])  async throws -> T? {
        do {
            let request = self.donMakeRequest(type: type, baseURL: baseURL,
                                              accessToken: accessToken, body: body,
                                              pathVariables: pathVariables)
            let (data, response) = try await URLSession.shared.data(for: request)
            dump(request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.responseError
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                let result = try JSONDecoder().decode(T.self, from: data)
                return result
            case 400:
                throw NetworkError.badRequestError
            case 401:
                throw NetworkError.unautohorizedError
            case 404:
                throw NetworkError.notFoundError
            case 500:
                throw NetworkError.internalServerError
            default:
                throw NetworkError.unknownError
            }
        } catch {
            throw error
        }
    }
}
