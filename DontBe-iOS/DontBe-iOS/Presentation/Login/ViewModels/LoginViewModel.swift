//
//  LoginViewModel.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/8/24.
//

import Combine
import Foundation

import KakaoSDKUser

final class LoginViewModel: ViewModelType {
    private let cancelBag = CancelBag()
    
    struct Input {
        let kakaoButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let userInfoPublisher: PassthroughSubject<String, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let userInfoPublisher = PassthroughSubject<String, Never>()
        
        input.kakaoButtonTapped
            .sink { _ in
                if (UserApi.isKakaoTalkLoginAvailable()) {
                    UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                        if let error {
                            print(error)
                        } else {
                            if let accessToken = oauthToken?.accessToken {
                                userInfoPublisher.send(accessToken)
                            }
                        }
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                        if let error {
                            print(error)
                        } else {
                            if let accessToken = oauthToken?.accessToken {
                                userInfoPublisher.send(accessToken)
                            }
                        }
                    }
                }
            }
            .store(in: self.cancelBag)
        
        return Output(userInfoPublisher: userInfoPublisher)
    }
}
