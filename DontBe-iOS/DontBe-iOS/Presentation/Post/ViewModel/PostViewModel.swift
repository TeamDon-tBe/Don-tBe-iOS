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
    private let toggleLikeButton = PassthroughSubject<Bool, Never>()
    var isLikeButtonClicked: Bool = false
    
    var postDetailData: [String] = []
    
    struct Input {
        let viewUpdate: AnyPublisher<Int, Never>
        let likeButtonTapped: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let getPostData: PassthroughSubject<PostDetailResponseDTO, Never>
        let toggleLikeButton: PassthroughSubject<Bool, Never>
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
                                self.isLikeButtonClicked = data.isLiked
                                self.getPostData.send(data)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: self.cancelBag)
        
        input.likeButtonTapped
            .sink {  value in
                Task {
                    do {
                        if self.isLikeButtonClicked {
                            let statusCode = try await self.postUnlikeButtonAPI(contentId: value)?.status
                            if statusCode == 200 {
                                self.isLikeButtonClicked.toggle()
                                self.toggleLikeButton.send(self.isLikeButtonClicked)
                            }
                        } else {
                            let statusCode = try await self.postLikeButtonAPI(contentId: value)?.status
                            if statusCode == 201 {
                                self.isLikeButtonClicked.toggle()
                                self.toggleLikeButton.send(self.isLikeButtonClicked)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: self.cancelBag)
        
        return Output(getPostData: getPostData, toggleLikeButton: toggleLikeButton)
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
    
    private func postLikeButtonAPI(contentId: Int) async throws -> BaseResponse<EmptyResponse>? {
        do {
            guard let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") else { return nil }
            let requestDTO = ContentLikeRequestDTO(alarmTriggerType: "contentLiked")
            let data: BaseResponse<EmptyResponse>? = try await
            self.networkProvider.donNetwork(
                type: .post,
                baseURL: Config.baseURL + "/content/\(contentId)/liked",
                accessToken: accessToken,
                body: requestDTO,
                pathVariables: ["":""]
            )
            print ("👻👻👻👻👻게시글 좋아요 버튼 클릭👻👻👻👻👻")
            return data
        } catch {
            return nil
        }
    }
    
    private func postUnlikeButtonAPI(contentId: Int) async throws -> BaseResponse<EmptyResponse>? {
        do {
            guard let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") else { return nil }
            let data: BaseResponse<EmptyResponse>? = try await
            self.networkProvider.donNetwork(
                type: .delete,
                baseURL: Config.baseURL + "/content/\(contentId)/unliked",
                accessToken: accessToken,
                body: EmptyBody(),
                pathVariables: ["":""]
            )
            print ("👻👻👻👻👻게시글 좋아요 취소 버튼 클릭👻👻👻👻👻")
            return data
        } catch {
            return nil
        }
    }
}
