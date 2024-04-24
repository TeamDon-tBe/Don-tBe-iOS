//
//  OnboardingEndingViewModel.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/9/24.
//

import Combine
import Foundation

final class OnboardingEndingViewModel: ViewModelType {
    
    private let cancelBag = CancelBag()
    private let networkProvider: NetworkServiceType
    
    private var getProfileData = PassthroughSubject<MypageProfileResponseDTO, Never>()
    
    init(networkProvider: NetworkServiceType) {
        self.networkProvider = networkProvider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct Input {
        let viewWillAppear: AnyPublisher<Int, Never>
        let backButtonTapped: AnyPublisher<Void, Never>
        let startButtonTapped: AnyPublisher<String, Never>
        let skipButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let getProfileData: PassthroughSubject<MypageProfileResponseDTO, Never>
        let voidPublisher: PassthroughSubject<String, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let publisher = PassthroughSubject<String, Never>()
        
        input.viewWillAppear
            .sink { memberId in
                Task {
                    do {
                        if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                            let profileResult = try await self.getProfileInfoAPI(accessToken: accessToken, memberId: memberId)
                            if let data = profileResult?.data {
                                self.getProfileData.send(data)
                                
                                saveUserData(UserInfo(isSocialLogined: loadUserData()?.isSocialLogined ?? true,
                                                      isFirstUser: true,
                                                      isJoinedApp: true,
                                                      isOnboardingFinished: false,
                                                      userNickname: data.nickname,
                                                      memberId: loadUserData()?.memberId ?? 0,
                                                      userProfileImage: data.memberProfileUrl))
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: self.cancelBag)
        
        input.backButtonTapped
            .sink { _ in
                // back 버튼 누르면 바로 신호보냄
                publisher.send("back")
            }
            .store(in: self.cancelBag)
        
        input.startButtonTapped
            .sink { value in
                // 한 줄 소개 작성 서버통신
                Task {
                    do {
                        let statusCode = try await self.patchUserInfoAPI(inroduction: value)?.status
                        if statusCode == 200 {
                            publisher.send("start")
                        }
                    } catch {
                        print(error)
                    }
                }
                
                saveUserData(UserInfo(isSocialLogined:
                                        loadUserData()?.isSocialLogined ?? true,
                                      isFirstUser: false,
                                      isJoinedApp: true,
                                      isOnboardingFinished: true,
                                      userNickname: loadUserData()?.userNickname ?? "",
                                      memberId: loadUserData()?.memberId ?? 0,
                                      userProfileImage: loadUserData()?.userProfileImage ?? StringLiterals.Network.baseImageURL))
            }
            .store(in: self.cancelBag)
        
        input.skipButtonTapped
            .sink { _ in
                // 이때는 서버통신 X
                publisher.send("skip")
                saveUserData(UserInfo(isSocialLogined:
                                        loadUserData()?.isSocialLogined ?? true,
                                      isFirstUser: false,
                                      isJoinedApp: true,
                                      isOnboardingFinished: true,
                                      userNickname: loadUserData()?.userNickname ?? "",
                                      memberId: loadUserData()?.memberId ?? 0,
                                      userProfileImage: loadUserData()?.userProfileImage ?? StringLiterals.Network.baseImageURL))
            }
            .store(in: self.cancelBag)
        
        return Output(getProfileData: getProfileData,
                      voidPublisher: publisher)
    }
}

// MARK: - Network

extension OnboardingEndingViewModel {
    private func getProfileInfoAPI(accessToken: String, memberId: Int) async throws -> BaseResponse<MypageProfileResponseDTO>? {
        do {
            let result: BaseResponse<MypageProfileResponseDTO>? = try await self.networkProvider.donNetwork(
                type: .get,
                baseURL: Config.baseURL + "/viewmember/\(memberId)",
                accessToken: accessToken,
                body: EmptyBody(),
                pathVariables: ["":""])
            UserDefaults.standard.set(result?.data?.memberGhost ?? 0, forKey: "memberGhost")
            return result
        } catch {
            return nil
        }
    }
    
    private func patchUserInfoAPI(inroduction: String) async throws -> BaseResponse<EmptyResponse>? {
        do {
            let requestDTO = UserProfileRequestDTO(
                nickname: loadUserData()?.userNickname ?? "",
                is_alarm_allowed: true,
                member_intro: inroduction,
                profile_url: loadUserData()?.userProfileImage ?? StringLiterals.Network.baseImageURL)
            
            guard let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") else { return nil }
            let data: BaseResponse<EmptyResponse>? = try await self.networkProvider.donNetwork(
                type: .patch,
                baseURL: Config.baseURL + "/user-profile",
                accessToken: accessToken,
                body: requestDTO,
                pathVariables: ["":""])
            
            print ("👻👻👻👻👻한 줄 소개 작성 완료👻👻👻👻👻")
            return data
        } catch {
            return nil
        }
    }
    
    private func postWriteContentAPI(inroduction: String) async throws -> BaseResponse<EmptyResponse>? {
        do {
            guard let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") else { return nil }
            
            let data: BaseResponse<EmptyResponse>? = try await
            self.networkProvider.donNetwork(
                type: .post,
                baseURL: Config.baseURL + "/content",
                accessToken: accessToken,
                body: WriteContentRequestDTO(contentText: inroduction),
                pathVariables: ["":""]
            )
            print ("👻👻👻👻👻한 줄 소개 포스팅 완료👻👻👻👻👻")
            return data
        } catch {
            return nil
        }
    }
}
