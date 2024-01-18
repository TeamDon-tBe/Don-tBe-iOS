//
//  DeleteReplyViewModel.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/18/24.
//

import Foundation
import Combine

final class DeleteReplyViewModel: ViewModelType {
    
    private let cancelBag = CancelBag()
    private let networkProvider: NetworkServiceType
    private let popView = PassthroughSubject<Void, Never>()
    
    struct Input {
        let deleteButtonDidTapped: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let popView: PassthroughSubject<Void, Never>
        
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.deleteButtonDidTapped
            .sink { value in
                Task {
                    do {
                        if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                            let statusCode = try await self.deleteReplyAPI(accessToken: accessToken, commentId: value)?.status
                            if statusCode == 200 {
                                self.popView.send()
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: self.cancelBag)
        return Output(popView: popView)
    }
    
    init(networkProvider: NetworkServiceType) {
        self.networkProvider = networkProvider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DeleteReplyViewModel {
    private func deleteReplyAPI(accessToken: String, commentId: Int) async throws -> BaseResponse<EmptyResponse>? {
        let accessToken = accessToken
        do {
            let result: BaseResponse<EmptyResponse>? = try
            await self.networkProvider.donNetwork(type: .delete, baseURL: Config.baseURL + "/comment/\(commentId)", accessToken: accessToken, body: EmptyBody(), pathVariables: ["":""])
            
            return result
        } catch {
            return nil
        }
    }
}

