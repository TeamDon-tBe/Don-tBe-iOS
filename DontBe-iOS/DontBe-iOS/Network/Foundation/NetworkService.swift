//
//  NetworkService.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/14/24.
//

import UIKit

final class NetworkService: NetworkServiceType {
    private let tokenManager = TokenManager()
    
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
        
        if type == .get {
            request.httpBody = nil
        } else {
            // 리퀘스트 바디 설정 (구조체)
            do {
                let jsonData = try JSONEncoder().encode(body)
                request.httpBody = jsonData
            } catch {
                print("Failed to encode request body: \(error)")
            }
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
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.responseError
            }
            
            switch httpResponse.statusCode {
            case 200..<401:
                let result = try JSONDecoder().decode(T.self, from: data)
                return result
            case 401:
                // Network 요청 중 401 에러가 발생하면 여기로
                guard let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") else { throw NetworkError.responseError }
                guard let refreshToken = KeychainWrapper.loadToken(forKey: "refreshToken") else { throw NetworkError.responseError }
                
                let result = try await tokenManager.getTokenAPI(accessToken: accessToken, refreshToken: refreshToken)
                if result.status == 401 && result.message == StringLiterals.Network.expired {
                    // 401 에러 중 accessToken, refreshToken 둘 다 만료된 경우 소셜로그인 화면으로
                    if let sceneDelegate = await UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        DispatchQueue.main.async {
                            let rootViewController = LoginViewController(viewModel: LoginViewModel(networkProvider: NetworkService()))
                            sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: rootViewController)
                        }
                    }
                    return nil
                } else {
                    guard let newAccessToken = result.data?.accessToken else { throw NetworkError.unknownError }
                    KeychainWrapper.saveToken(accessToken, forKey: "accessToken")

                    return try await donNetwork(type: type, baseURL: baseURL, accessToken: newAccessToken, body: body, pathVariables: pathVariables)
                }
            case 404:
                if let sceneDelegate = await UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    DispatchQueue.main.async {
                        let viewController = ErrorViewController()
                        sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: viewController)
                    }
                }
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
