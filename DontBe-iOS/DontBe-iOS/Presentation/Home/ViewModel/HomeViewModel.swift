//
//  HomeViewModel.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/8/24.
//

import Foundation

import Combine

final class HomeViewModel: ViewModelType {
    
    private let cancelBag = CancelBag()
    private let networkProvider: NetworkServiceType
    private var getData = PassthroughSubject<Void, Never>()
    private let toggleLikeButton = PassthroughSubject<Bool, Never>()
    var isLikeButtonClicked: Bool = false
    
    var postData: [PostDataResponseDTO] = []
    
    struct Input {
        let viewUpdate: AnyPublisher<Void, Never>?
        let likeButtonTapped: AnyPublisher<(Bool, Int), Never>?
    }

    struct Output {
        let getData: PassthroughSubject<Void, Never>
        let toggleLikeButton: PassthroughSubject<Bool, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.viewUpdate?
            .sink { [self] _ in
                Task {
                    do {
                        if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                            let result = try await
                            self.getPostDataAPI(accessToken: accessToken)
                            if let data = result?.data {
                                var tempArray: [PostDataResponseDTO] = []
                                for content in data {
                                    tempArray.append(content)
                                }
                                self.postData = tempArray
                                self.getData.send()
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
                        if value.0 == true {
                            let statusCode = try await self.postUnlikeButtonAPI(contentId: value.1)?.status
                            if statusCode == 200 {
                                self.toggleLikeButton.send(!value.0)
                            }
                        } else {
                            let statusCode = try await self.postLikeButtonAPI(contentId: value.1)?.status
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
        
        return Output(getData: getData, toggleLikeButton: toggleLikeButton)
    }
    
    init(networkProvider: NetworkServiceType) {
        self.networkProvider = networkProvider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeViewModel {
    private func getPostDataAPI(accessToken: String) async throws -> BaseResponse<[PostDataResponseDTO]>? {
        do {
            let result: BaseResponse<[PostDataResponseDTO]>? = try await
            self.networkProvider.donNetwork(type: .get,
                                            baseURL: Config.baseURL + "/content/all",
                                            accessToken: accessToken,
                                            body: EmptyBody(),
                                            pathVariables: ["":""])
            
            if let data = result?.data {
                var tempArrayData: [PostDataResponseDTO] = []
                
                for content in data {
                    tempArrayData.append(content)
                }
                self.postData = tempArrayData
            }
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
