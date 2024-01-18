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

    init(networkProvider: NetworkServiceType) {
        self.networkProvider = networkProvider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct Input {
        let backButtonTapped: AnyPublisher<Void, Never>
        let startButtonTapped: AnyPublisher<String, Never>
        let skipButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let voidPublisher: PassthroughSubject<String, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let publisher = PassthroughSubject<String, Never>()
        
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
                        _ = try await self.postWriteContentAPI(inroduction: value)
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
                                         memberId: loadUserData()?.memberId ?? 0))
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
                                        memberId: loadUserData()?.memberId ?? 0))
            }
            .store(in: self.cancelBag)
        
        return Output(voidPublisher: publisher)
    }
}

// MARK: - Network

extension OnboardingEndingViewModel {
    private func patchUserInfoAPI(inroduction: String) async throws -> BaseResponse<EmptyResponse>? {
        do {
            let requestDTO = UserProfileRequestDTO(
                nickname: loadUserData()?.userNickname ?? "",
                is_alarm_allowed: true,
                member_intro: inroduction,
                profile_url: StringLiterals.Network.baseImageURL)

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
