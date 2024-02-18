//
//  LoginViewModel.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/8/24.
//

import AuthenticationServices
import Combine
import Foundation

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

final class LoginViewModel: NSObject, ViewModelType {
    
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
        let kakaoButtonTapped: AnyPublisher<Void, Never>?
        let appleButtonTapped: AnyPublisher<Void, Never>?
    }
    
    struct Output {
        let userInfoPublisher: PassthroughSubject<Bool, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.kakaoButtonTapped?
            .sink {
                self.performKakaoLogin()
            }
            .store(in: cancelBag)
        
        input.appleButtonTapped?
            .sink {
                self.performAppleLogin()
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
    
    private func performAppleLogin() {
        let appleProvider = ASAuthorizationAppleIDProvider()
        let request = appleProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    private func handleKakaoLoginResult(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
            print(error)
        } else if let accessToken = oauthToken?.accessToken {
            // 소셜로그인 서버통신
            Task {
                do {
                    let result = try await self.postSocialLoginAPI(accessToken: accessToken)?.data
                    let isNewUser = result?.isNewUser ?? false
                    let nickname = result?.nickName ?? ""
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
        let requestDTO = SocialLoginRequestDTO(socialPlatform: "KAKAO")
        do {
            let data: BaseResponse<SocialLoginResponseDTO>? = try await self.networkProvider.donNetwork(
                type: .post,
                baseURL: Config.baseURL + "/auth",
                accessToken: accessToken,
                body: requestDTO,
                pathVariables: ["":""])
            print ("👻👻👻👻👻소셜로그인 서버통신👻👻👻👻👻")
            
            if data?.status == 400 {
                print(NetworkError.badRequestError)
            }
            
            // UserInfo 구조체에 유저 정보 저장
            let userNickname = data?.data?.nickName ?? ""
            let isNewUser = data?.data?.isNewUser ?? true
            let memberId = data?.data?.memberId ?? 0
            saveUserData(UserInfo(isSocialLogined: true,
                                  isFirstUser: isNewUser,
                                  isJoinedApp: false,
                                  isOnboardingFinished: false,
                                  userNickname: userNickname,
                                  memberId: memberId))
            
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

extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        if let fullName = credential.fullName,
           let identifyToken = credential.authorizationCode {
            print((fullName.familyName ?? "") + (fullName.givenName ?? ""))
            let token = String(data: identifyToken, encoding: .utf8)
            print(token ?? "")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}
