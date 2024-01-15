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
                self.performKakaoLogin()
            }
            .store(in: cancelBag)
        
        return Output(userInfoPublisher: userInfoPublisher)
    }
    
    private func performKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                self?.handleKakaoLoginResult(oauthToken: oauthToken, error: error)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                self?.handleKakaoLoginResult(oauthToken: oauthToken, error: error)
            }
        }
    }
    
    private func handleKakaoLoginResult(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
            print(error)
        } else if let accessToken = oauthToken?.accessToken {
            Task {
                do {
                    let isNewUser = try await self.postSocialLoginAPI(accessToken: accessToken)?.data?.isNewUser ?? false
                    let nickname = try await self.postSocialLoginAPI(accessToken: accessToken)?.data?.nickName ?? ""
                    if !isNewUser && !nickname.isEmpty {
                        self.userInfoPublisher.send(false)
                    } else {
                        self.userInfoPublisher.send(true)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

// MARK: - Network

extension LoginViewModel {
    private func postSocialLoginAPI(accessToken: String) async throws -> BaseResponse<SocialLoginResponseDTO>? {
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
            print(accessToken)
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
