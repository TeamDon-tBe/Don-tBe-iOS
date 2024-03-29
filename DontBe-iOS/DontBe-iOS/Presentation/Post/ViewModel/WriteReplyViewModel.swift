//
//  WriteReplyViewModel.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/17/24.
//

import Foundation
import Combine

import Amplitude

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
                Task {
                    do {
                        if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                            
                            if let resultStatus = try await self.postWriteReplyContentAPI(accessToken: "\(accessToken)", commentText: value.0, contentId: value.1, notificationTriggerType: "comment") {
                                print(resultStatus.status)
                                self.popViewController.send(true)
                                
                                Amplitude.instance().logEvent("click_reply_upload")
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
    private func postWriteReplyContentAPI(accessToken: String, commentText: String, contentId: Int, notificationTriggerType: String) async throws -> BaseResponse<EmptyResponse>? {
        do {
            let result: BaseResponse<EmptyResponse>? = try await
            self.networkProvider.donNetwork(
                type: .post,
                baseURL: Config.baseURL + "/content/\(contentId)/comment",
                accessToken: accessToken,
                body: WriteReplyRequestDTO(commentText: commentText, notificationTriggerType: notificationTriggerType),
                pathVariables: ["":""]
            )
            return result
        } catch {
            return nil
        }
    }
}
