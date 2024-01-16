//
//  WriteViewModel.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/15/24.
//

import Combine
import Foundation

final class WriteViewModel: ViewModelType {
    
    private let cancelBag = CancelBag()
    private let networkProvider: NetworkServiceType
    
    private let popViewController = PassthroughSubject<Bool, Never>()
    
    struct Input {
        let postButtonTapped: AnyPublisher<String, Never>
    }
    
    struct Output {
        let popViewController: PassthroughSubject<Bool, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.postButtonTapped
            .sink { value in
                Task {
                    do {
                        if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                            if let resultStatus = try await self.postWriteContentAPI(accessToken: "\(accessToken)", contentText: "\(value)") {
                                self.popViewController.send(true)
                            }
                        }
                    } catch {
                        print(error)
                    }
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
}
