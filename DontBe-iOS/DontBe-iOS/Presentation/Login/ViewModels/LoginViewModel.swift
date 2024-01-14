//
//  LoginViewModel.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/8/24.
//

import Combine
import Foundation

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

final class LoginViewModel: ViewModelType {
    
    private let cancelBag = CancelBag()
    private let networkProvider: SocialLoginServiceType
    private let userInfoPublisher = PassthroughSubject<Bool, Never>()
    
    init(networkProvider: SocialLoginServiceType) {
        self.networkProvider = networkProvider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct Input {
        let kakaoButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let userInfoPublisher: PassthroughSubject<Bool, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.kakaoButtonTapped
            .sink {
                Task {
                    do {
                        if UserApi.isKakaoTalkLoginAvailable() {
                            let oauthToken = try await self.loginWithKakaoTalk()
                            try await self.handleLoginResult(oauthToken: oauthToken)
                        } else {
                            let oauthToken = try await self.loginWithKakaoAccount()
                            try await self.handleLoginResult(oauthToken: oauthToken)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: self.cancelBag)
        
        return Output(userInfoPublisher: userInfoPublisher)
    }
}

extension LoginViewModel {
    private func loginWithKakaoTalk() async throws -> OAuthToken {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let oauthToken = oauthToken {
                    continuation.resume(returning: oauthToken)
                }
            }
        }
    }

    private func loginWithKakaoAccount() async throws -> OAuthToken {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let oauthToken = oauthToken {
                    continuation.resume(returning: oauthToken)
                }
            }
        }
    }

    private func handleLoginResult(oauthToken: OAuthToken) async throws {
        let accessToken = oauthToken.accessToken
        let isNewUser = try await postSocialLoginAPI(accessToken: accessToken)
        userInfoPublisher.send(isNewUser)
        print("카카오 로그인 성공 👻👻👻👻👻")
    }
    
    private func postSocialLoginAPI(accessToken: String) async -> Bool {
        do {
            if let result = try await networkProvider.postData(accessToken: accessToken) {
                let isNewUser = result.data?.isNewUser ?? true
                if isNewUser {
                    saveUserData(UserInfo(isSocialLogined: true,
                                          isJoinedApp: true,
                                          isNotFirstUser: true,
                                          isOnboardingFinished: false,
                                          userNickname: ""))
                } else {
                    saveUserData(UserInfo(isSocialLogined: true,
                                          isJoinedApp: false,
                                          isNotFirstUser: false,
                                          isOnboardingFinished: false,
                                          userNickname: ""))
                }
                return isNewUser
            }
        } catch {
            print(error)
        }
        return false
    }
}
