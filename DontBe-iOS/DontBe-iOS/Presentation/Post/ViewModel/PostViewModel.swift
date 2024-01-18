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
    private var getPostReplyData = PassthroughSubject<[PostReplyResponseDTO], Never>()
    
    private let toggleCommentLikeButton = PassthroughSubject<Bool, Never>()
    var isCommentLikeButtonClicked: Bool = false
    
    var postDetailData: [String] = []
    var postReplyData: [PostReplyResponseDTO] = []
    
    struct Input {
        let viewUpdate: AnyPublisher<Int, Never>?
        let likeButtonTapped: AnyPublisher<Int, Never>?
        let collectionViewUpdata: AnyPublisher<Int, Never>?
        let commentLikeButtonTapped: AnyPublisher<(Bool, Int, String), Never>?
    }
    
    struct Output {
        let getPostData: PassthroughSubject<PostDetailResponseDTO, Never>
        let toggleLikeButton: PassthroughSubject<Bool, Never>
        let getPostReplyData: PassthroughSubject<[PostReplyResponseDTO], Never>
        let toggleCommentLikeButton: PassthroughSubject<Bool, Never>

    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.viewUpdate?
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
        
        input.likeButtonTapped?
            .sink {  value in
                Task {
                    do {
                        if self.isLikeButtonClicked {
                            let statusCode = try await self.deleteLikeButtonAPI(contentId: value)?.status
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
        
        input.collectionViewUpdata?
            .sink { value in
                Task {
                    do {
                        if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                            let postReplyResult = try await
                            self.getPostReplyDataAPI(accessToken: accessToken, contentId: value)
                            if let data = postReplyResult?.data {
                                self.postReplyData = data
                                self.getPostReplyData.send(data)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: self.cancelBag)
        input.commentLikeButtonTapped?
            .sink {  value in
                Task {
                    do {
                        print(value.1)
                        if value.0 == true {
                            let statusCode = try await self.deleteCommentLikeButtonAPI(commentId: value.1)?.status
                            print(statusCode)
                            if statusCode == 201 {
                                self.toggleLikeButton.send(!value.0)
                            }
                        } else {
                            let statusCode = try await self.postCommentLikeButtonAPI(commentId: value.1, alarmText: value.2)?.status
                            print(statusCode)
                            if statusCode == 201 {
                                self.toggleLikeButton.send(value.0)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: self.cancelBag)
        
        return Output(getPostData: getPostData, toggleLikeButton: toggleLikeButton, getPostReplyData: getPostReplyData, toggleCommentLikeButton: toggleCommentLikeButton)
    }
    
    
    init(networkProvider: NetworkServiceType) {
        self.networkProvider = networkProvider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Network

extension PostViewModel {
    private func getPostDetailDataAPI(accessToken: String, contentId: Int) async throws -> BaseResponse<PostDetailResponseDTO>? {
        do {
            let result: BaseResponse<PostDetailResponseDTO>? = try
            await self.networkProvider.donNetwork(type: .get, baseURL: Config.baseURL + "/content/\(contentId)/detail", accessToken: accessToken, body: EmptyBody(), pathVariables: ["":""])
            return result
        } catch {
            return nil
        }
    }
    
    private func getPostReplyDataAPI(accessToken: String, contentId: Int) async throws -> BaseResponse<[PostReplyResponseDTO]>? {
        do {
            let result: BaseResponse<[PostReplyResponseDTO]>? = try await
            self.networkProvider.donNetwork(type: .get,
                                            baseURL: Config.baseURL + "/content/\(contentId)/comment/all",
                                            accessToken: accessToken,
                                            body: EmptyBody(),
                                            pathVariables: ["":""])
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
            print ("👻👻👻👻👻게시물 좋아요 버튼 클릭👻👻👻👻👻")
            return data
        } catch {
            return nil
        }
    }
    
    private func deleteLikeButtonAPI(contentId: Int) async throws -> BaseResponse<EmptyResponse>? {
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
            print ("👻👻👻👻👻게시물 좋아요 취소 버튼 클릭👻👻👻👻👻")
            return data
        } catch {
            return nil
        }
    }
    
    private func postCommentLikeButtonAPI(commentId: Int, alarmText: String)  async throws -> BaseResponse<EmptyResponse>? {
        do {
            guard let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") else { return nil }
            let requestDTO = CommentLikeRequestDTO(notificationTriggerType: "comment", notificationText: alarmText)
            let data: BaseResponse<EmptyResponse>? = try await
            self.networkProvider.donNetwork(
                type: .post,
                baseURL: Config.baseURL + "/comment/\(commentId)/liked",
                accessToken: accessToken,
                body: requestDTO,
                pathVariables: ["":""]
            )
            print ("👻👻👻👻👻답글 좋아요 버튼 클릭👻👻👻👻👻")
            return data
        } catch {
            return nil
        }
    }
    
    private func deleteCommentLikeButtonAPI(commentId: Int)  async throws -> BaseResponse<EmptyResponse>? {
        do {
            guard let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") else { return nil }
            let data: BaseResponse<EmptyResponse>? = try await
            self.networkProvider.donNetwork(
                type: .delete,
                baseURL: Config.baseURL + "/comment/\(commentId)/unliked",
                accessToken: accessToken,
                body: EmptyBody(),
                pathVariables: ["":""]
            )
            print ("👻👻👻👻👻답글 좋아요 취소 버튼 클릭👻👻👻👻👻")
            return data
        } catch {
            return nil
        }
    }
}
