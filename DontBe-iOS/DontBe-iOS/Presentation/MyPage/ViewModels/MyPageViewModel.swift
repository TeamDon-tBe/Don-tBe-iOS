//
//  MyPageMemberDataViewModel.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/14/24.
//

import Combine
import Foundation

final class MyPageViewModel: ViewModelType {
    
    private let cancelBag = CancelBag()
    private let networkProvider: NetworkServiceType
    private var getData = PassthroughSubject<Void, Never>()
    private var getProfileData = PassthroughSubject<MypageProfileResponseDTO, Never>()
    private var getContentData = PassthroughSubject<[MyPageMemberContentResponseDTO], Never>()
    private var getCommentData = PassthroughSubject<[MyPageMemberCommentResponseDTO], Never>()
    
    var myPageMemberData: [String] = []
    var myPageProfileData: [MypageProfileResponseDTO] = []
    var myPageContentData: [MyPageMemberContentResponseDTO] = []
    var myPageCommentData: [MyPageMemberCommentResponseDTO] = []
    private var memberId: Int = loadUserData()?.memberId ?? 0
    
    struct Input {
        let viewUpdate: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let getData: PassthroughSubject<Void, Never>
        let getProfileData: PassthroughSubject<MypageProfileResponseDTO, Never>
        let getContentData: PassthroughSubject<[MyPageMemberContentResponseDTO], Never>
        let getCommentData: PassthroughSubject<[MyPageMemberCommentResponseDTO], Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.viewUpdate
            .sink { value in
                if value == 0 {
                    // 계정 정보 조회 API
                    Task {
                        do {
                            if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                                let result = try await self.getMyPageMemberDataAPI(accessToken: accessToken)
                                if let data = result?.data {
                                    self.myPageMemberData = [data.socialPlatform, data.versionInformation, data.showMemberId ?? "money_rain_is_coming", data.joinDate]
                                    self.getData.send()
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                } else if value == 1 {
                    // 유저 프로필 조회 API
                    Task {
                        do {
                            if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                                let profileResult = try await self.getProfileInfoAPI(accessToken: accessToken, memberId: "\(self.memberId)")
                                if let data = profileResult?.data {
                                    self.myPageProfileData.append(data)
                                    self.getProfileData.send(data)
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                    
                    // 유저에 해당하는 게시글 리스트 조회
                    Task {
                        do {
                            if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                                let contentResult = try await self.getMemberContentAPI(accessToken: accessToken, memberId: "\(self.memberId)")
                                if let data = contentResult?.data {
                                    self.myPageContentData = data
                                    self.getContentData.send(data)
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                    
                    // 유저에 해당하는 답글 리스트 조회
                    Task {
                        do {
                            if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                                let commentResult = try await self.getMemberCommentAPI(accessToken: accessToken, memberId: "\(self.memberId)")
                                if let data = commentResult?.data {
                                    self.myPageCommentData = data
                                    self.getCommentData.send(data)
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            .store(in: self.cancelBag)
        
        return Output(getData: getData, getProfileData: getProfileData, getContentData: getContentData, getCommentData: getCommentData)
    }
    
    init(networkProvider: NetworkServiceType) {
        self.networkProvider = networkProvider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageViewModel {
    private func getMyPageMemberDataAPI(accessToken: String) async throws -> BaseResponse<MyPageAccountInfoResponseDTO>? {
        do {
            let result: BaseResponse<MyPageAccountInfoResponseDTO>? = try await self.networkProvider.donNetwork(
                type: .get,
                baseURL: Config.baseURL + "/member-data",
                accessToken: accessToken,
                body: EmptyBody(),
                pathVariables: ["":""])
            return result
        } catch {
            return nil
        }
    }
    
    private func getProfileInfoAPI(accessToken: String, memberId: String) async throws -> BaseResponse<MypageProfileResponseDTO>? {
        do {
            let result: BaseResponse<MypageProfileResponseDTO>? = try await self.networkProvider.donNetwork(
                type: .get,
                baseURL: Config.baseURL + "/viewmember/\(memberId)",
                accessToken: accessToken,
                body: EmptyBody(),
                pathVariables: ["":""])
            return result
        } catch {
            return nil
        }
    }
    
    private func getMemberContentAPI(accessToken: String, memberId: String) async throws -> BaseResponse<[MyPageMemberContentResponseDTO]>? {
        do {
            let result: BaseResponse<[MyPageMemberContentResponseDTO]>? = try await self.networkProvider.donNetwork(
                type: .get,
                baseURL: Config.baseURL + "/member/\(memberId)/contents",
                accessToken: accessToken,
                body: EmptyBody(),
                pathVariables:["":""])
            return result
        } catch {
            return nil
        }
    }
    
    private func getMemberCommentAPI(accessToken: String, memberId: String) async throws -> BaseResponse<[MyPageMemberCommentResponseDTO]>? {
        do {
            let result: BaseResponse<[MyPageMemberCommentResponseDTO]>? = try await self.networkProvider.donNetwork(
                type: .get,
                baseURL: Config.baseURL + "/member/\(memberId)/comments",
                accessToken: accessToken,
                body: EmptyBody(),
                pathVariables:["":""])
            return result
        } catch {
            return nil
        }
    }
}
