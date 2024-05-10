//
//  WriteViewModel.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/15/24.
//

import Combine
import Foundation
import UIKit

import Amplitude

final class WriteViewModel: ViewModelType {
    
    private let cancelBag = CancelBag()
    private let networkProvider: NetworkServiceType
    
    private let popViewController = PassthroughSubject<Bool, Never>()
    
    struct Input {
        let postButtonTapped: AnyPublisher<WriteContentImageRequestDTO, Never>
    }
    
    struct Output {
        let popViewController: PassthroughSubject<Bool, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.postButtonTapped
            .sink { value in
                Task {
                    self.postWriteContentAPI(contentText: value.contentText, photoImage: value.photoImage)
                    self.popViewController.send(true)
                }
            }
            .store(in: self.cancelBag)
        
        return Output(popViewController: popViewController)
    }
    
    init(networkProvider: NetworkServiceType) {
        self.networkProvider = networkProvider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WriteViewModel {
    private func postWriteContentAPI(accessToken: String, contentText: String) async throws -> BaseResponse<EmptyResponse>? {
        do {
            let result: BaseResponse<EmptyResponse>? = try await
            self.networkProvider.donNetwork(
                type: .post,
                baseURL: Config.baseURL + "/content",
                accessToken: accessToken,
                body: WriteContentRequestDTO(contentText: contentText),
                pathVariables: ["":""]
            )
            return result
        } catch {
            return nil
        }
    }
    
    private func postWriteContentAPI(contentText: String, photoImage: UIImage?) {
        guard let url = URL(string: Config.baseURL.dropLast() + "2/content") else { return }
        guard let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") else { return }
        
        let parameters: [String: Any] = [
            "contentText": contentText
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Multipart form data 생성
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        var requestBodyData = Data()
        
        // 게시글 본문 데이터 추가
        requestBodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        requestBodyData.append("Content-Disposition: form-data; name=\"text\"\r\n\r\n".data(using: .utf8)!)
        requestBodyData.append(try! JSONSerialization.data(withJSONObject: parameters, options: []))
        requestBodyData.append("\r\n".data(using: .utf8)!)
        
        if let image = photoImage {
            let imageData = image.jpegData(compressionQuality: 0.1)!
            
            // 게시글 이미지 데이터 추가
            requestBodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
            requestBodyData.append("Content-Disposition: form-data; name=\"image\"; filename=\"dontbe.jpeg\"\r\n".data(using: .utf8)!)
            requestBodyData.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            requestBodyData.append(imageData)
            requestBodyData.append("\r\n".data(using: .utf8)!)
        }
        
        requestBodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // HTTP body에 데이터 설정
        request.httpBody = requestBodyData
        
        // URLSession으로 요청 보내기
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error:", error)
                return
            }
            
            // 응답 처리
            if let response = response as? HTTPURLResponse {
                print(response)
                print("Response status code:", response.statusCode)
            }
            
            if let data = data {
                // 서버 응답 데이터 처리
                print("Response data:", String(data: data, encoding: .utf8) ?? "Empty response")
            }
        }
        task.resume()
    }
}
