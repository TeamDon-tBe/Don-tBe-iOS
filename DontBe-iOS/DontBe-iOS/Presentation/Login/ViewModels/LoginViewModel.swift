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
    private let networkProvider: NetworkServiceType
    private let userInfoPublisher = PassthroughSubject<Bool, Never>()
    
    init(networkProvider: NetworkServiceType) {
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
                            let isNewUser = try await self.getSocialLoginAPI(oauthToken: oauthToken)?.data?.isNewUser ?? false
                            self.userInfoPublisher.send(isNewUser)
                        } else {
                            let oauthToken = try await self.loginWithKakaoAccount()
                            let isNewUser = try await self.getSocialLoginAPI(oauthToken: oauthToken)?.data?.isNewUser ?? false
                            self.userInfoPublisher.send(isNewUser)
                        }
                        print("👻👻👻👻👻카카오 로그인 성공👻👻👻👻👻")
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
    
    private func getSocialLoginAPI(oauthToken: OAuthToken) async throws -> BaseResponse<SocialLoginResponseDTO>? {
        let accessToken = oauthToken.accessToken
        do {
            let data: BaseResponse<SocialLoginResponseDTO>? = try await self.networkProvider.donNetwork(
                type: .post,
                baseURL: Config.baseURL + "/auth",
                accessToken: accessToken,
                body: SocialLoginRequestDTO(socialPlatform: "KAKAO"),
                pathVariables: ["":""])
            print ("👻👻👻👻👻소셜로그인 서버통신👻👻👻👻👻")
            
            // UserInfo 구조체에 유저 정보 저장
            let userNickname = data?.data?.nickName ?? ""
            let isNewUser = data?.data?.isNewUser ?? true
            saveUserData(UserInfo(isSocialLogined: true,
                                  isFirstUser: isNewUser,
                                  isJoinedApp: false,
                                  isOnboardingFinished: false,
                                  userNickname: userNickname))
            
            // KeychainWrapper에 Access Token 저장
            let accessToken = data?.data?.accessToken ?? ""
            KeychainWrapper.saveToken(accessToken, forKey: "accessToken")
            
            // KeychainWrasapper에 Refresh Token 저장
            let refreshToken = data?.data?.refreshToken ?? ""
            KeychainWrapper.saveToken(refreshToken, forKey: "refreshToken")

            return data
        }
        catch {
           return nil
       }
    }
}
