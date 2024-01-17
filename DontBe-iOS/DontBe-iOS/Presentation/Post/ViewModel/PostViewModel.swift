//
//  PostViewModel.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/17/24.
//

import Foundation
import Combine

final class PostViewModel: ViewModelType {
    
    private let cancelBag = CancelBag()
    private let networkProvider: NetworkServiceType
    private var getPostData = PassthroughSubject<PostDetailResponseDTO, Never>()
    
    var postDetailData: [String] = []
    
    struct Input {
        let viewUpdate: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let getPostData: PassthroughSubject<PostDetailResponseDTO, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.viewUpdate
            .sink { value in
                Task {
                    do {
                        if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                            let postResult = try await
                            self.getPostDetailDataAPI(accessToken: accessToken, contentId: value)
                            if let data = postResult?.data {
                                self.getPostData.send(data)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: self.cancelBag)
        return Output(getPostData: getPostData)
    }
    
    init(networkProvider: NetworkServiceType) {
        self.networkProvider = networkProvider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostViewModel {
    private func getPostDetailDataAPI(accessToken: String, contentId: Int) async throws -> BaseResponse<PostDetailResponseDTO>? {
        let accessToken = accessToken
        do {
            let result: BaseResponse<PostDetailResponseDTO>? = try
            await self.networkProvider.donNetwork(type: .get, baseURL: Config.baseURL + "/content/\(contentId)/detail", accessToken: accessToken, body: EmptyBody(), pathVariables: ["":""])
            
            return result
        } catch {
            return nil
        }
    }
    
    func postDownTransparency(accessToken: String, alarmTriggerType: String, targetMemberId: Int, alarmTriggerId: Int) async throws -> BaseResponse<EmptyResponse>? {
        do {
            let result: BaseResponse<EmptyResponse>? = try await
            self.networkProvider.donNetwork(type: .post,
                                            baseURL: Config.baseURL + "/ghost",
                                            accessToken: accessToken,
                                            body: PostTransparencyRequestDTO(
                                                alarmTriggerType: alarmTriggerType,
                                                targetMemberId: targetMemberId,
                                                alarmTriggerId: alarmTriggerId
                                            ),
                                            pathVariables: ["":""])
            return result
        } catch {
            return nil
        }
    }
}
