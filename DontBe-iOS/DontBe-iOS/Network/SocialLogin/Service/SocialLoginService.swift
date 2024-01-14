//
//  KakaoLoginService.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/14/24.
//

import Foundation
import Foundation

protocol SocialLoginServiceType {
    func makeRequestURL(accessToken: String) -> URLRequest
    func postData(accessToken: String) async throws -> BaseResponse<SocialLoginResponseDTO>?
    func parseData(data: Data) -> BaseResponse<SocialLoginResponseDTO>?
}

final class SocialLoginService: SocialLoginServiceType {
    
    func makeRequestURL(accessToken: String) -> URLRequest {
        
        let baseURL = Config.baseURL
        
        let urlString = "\(baseURL)/auth"
        
        // URL 생성
        guard let url = URL(string: urlString) else {
            fatalError("Failed to create URL")
        }
        
        // URLRequest 생성
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // 헤더 추가
        let header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]
        header.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        // 리퀘스트 바디 설정
        let requestBody = SocialLoginRequestDTO(socialPlatform: "KAKAO")
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
                request.httpBody = jsonData
        } catch {
            print("Failed to encode request body: \(error)")
        }
        
        return request
    }
    
    func postData(accessToken: String) async throws -> BaseResponse<SocialLoginResponseDTO>? {
        do {
            let request = self.makeRequestURL(accessToken: accessToken)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.responseError
            }
    
            switch httpResponse.statusCode {
            case 200..<300:
                return parseData(data: data)
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
    
    func parseData(data: Data) -> BaseResponse<SocialLoginResponseDTO>? {
        do {
            let jsonDecoder = JSONDecoder()
            let result = try jsonDecoder.decode(BaseResponse<SocialLoginResponseDTO>.self, from: data)
            return result
        } catch {
            print(error)
            return nil
        }
    }
}
