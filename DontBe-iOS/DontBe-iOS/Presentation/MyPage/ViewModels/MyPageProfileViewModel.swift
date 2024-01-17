//
//  MyPageProfileViewModel.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/17/24.
//

import Combine
import Foundation

final class MyPageProfileViewModel: ViewModelType {
    
    private let cancelBag = CancelBag()
    private let networkProvider: NetworkServiceType
    private let popViewController = PassthroughSubject<Void, Never>()
    private let isNotDuplicated = PassthroughSubject<Bool, Never>()
    
    init(networkProvider: NetworkServiceType) {
        self.networkProvider = networkProvider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    struct Input {
        let backButtonTapped: AnyPublisher<Void, Never>
        let duplicationCheckButtonTapped: AnyPublisher<String, Never>
        let finishButtonTapped: AnyPublisher<UserProfileRequestDTO, Never>
    }
    
    struct Output {
        let popViewController: PassthroughSubject<Void, Never>
        let isEnable: PassthroughSubject<Bool, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.backButtonTapped
            .sink { _ in
                self.popViewController.send()
            }
            .store(in: self.cancelBag)
        
        input.duplicationCheckButtonTapped
            .sink { value in
                // 닉네임 중복체크 서버통신
                Task {
                    do {
                        let statusCode = try await self.getNicknameDuplicationAPI(nickname: value)?.status ?? 200
                        if statusCode == 200 {
                            self.isNotDuplicated.send(true)
                        } else {
                            self.isNotDuplicated.send(false)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: self.cancelBag)
        
        input.finishButtonTapped
            .sink { value in
                Task {
                    do {
                        let statusCode = try await self.patchUserInfoAPI(nickname: value.nickname, member_intro: value.member_intro)?.status
                        if statusCode == 200 {
                            self.popViewController.send()
                        }
                    } catch {
                        print(error)
                    }
                }
                
                saveUserData(UserInfo(isSocialLogined: true,
                                      isFirstUser: false,
                                      isJoinedApp: true,
                                      isOnboardingFinished: true,
                                      userNickname: value.nickname,
                                      memberId: loadUserData()?.memberId ?? 0))
            }
            .store(in: self.cancelBag)
        
        return Output(popViewController: popViewController,
                      isEnable: isNotDuplicated)
    }
}

// MARK: - Network

extension MyPageProfileViewModel {
    private func getNicknameDuplicationAPI(nickname: String) async throws -> BaseResponse<EmptyResponse>? {
        do {
            guard let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") else { return nil }
            let data: BaseResponse<EmptyResponse>? = try await self.networkProvider.donNetwork(
                type: .get,
                baseURL: Config.baseURL + "/nickname-validation",
                accessToken: accessToken,
                body: EmptyBody(),
                pathVariables: ["nickname":nickname])
            return data
        } catch {
           return nil
       }
    }
    
    private func patchUserInfoAPI(nickname: String, member_intro: String) async throws -> BaseResponse<EmptyResponse>? {
        do {
            let requestDTO = UserProfileRequestDTO(nickname: nickname, is_alarm_allowed: true, member_intro: member_intro, profile_url: StringLiterals.Network.baseImageURL)

            guard let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") else { return nil }
            let data: BaseResponse<EmptyResponse>? = try await self.networkProvider.donNetwork(
                type: .patch,
                baseURL: Config.baseURL + "/user-profile",
                accessToken: accessToken,
                body: requestDTO,
                pathVariables: ["":""])
            return data
        } catch {
           return nil
       }
    }
}

