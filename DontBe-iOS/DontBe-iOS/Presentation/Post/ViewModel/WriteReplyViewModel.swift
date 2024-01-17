//
//  WriteReplyViewModel.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/17/24.
//

import Foundation
import Combine

final class WriteReplyViewModel: ViewModelType {
    
    private let cancelBag = CancelBag()
    private let networkProvider: NetworkServiceType
    
    private let popViewController = PassthroughSubject<Bool, Never>()
    
    struct Input {
        let postButtonTapped: AnyPublisher<(String, Int), Never>
    }
    
    struct Output {
        let popViewController: PassthroughSubject<Bool, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.postButtonTapped
            .sink { value in
                print("postButtonTapped")
                print("\(value)")
                Task {
                    do {
                        if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                            print("\(accessToken)")
                            if let resultStatus = try await self.postWriteReplyContentAPI(accessToken: "\(accessToken)", commentText: value.0, contentId: value.1) {
                                print("\(value.1)")
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

extension WriteReplyViewModel {
    private func postWriteReplyContentAPI(accessToken: String, commentText: String, contentId: Int) async throws -> BaseResponse<EmptyResponse>? {
        print("\(postWriteReplyContentAPI)")
        do {
            let result: BaseResponse<EmptyResponse>? = try await
            self.networkProvider.donNetwork(
                type: .post,
                baseURL: Config.baseURL + "/content/\(contentId)/comment",
                accessToken: accessToken,
                body: WriteReplyRequestDTO(commentText: commentText),
                pathVariables: ["":""]
            )
            return result
        } catch {
            return nil
        }
    }
}
