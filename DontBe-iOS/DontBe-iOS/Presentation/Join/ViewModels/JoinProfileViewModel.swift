//
//  JoinProfileViewModel.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/11/24.
//

import Combine
import Foundation

final class JoinProfileViewModel: ViewModelType {
    
    private let cancelBag = CancelBag()
    private let networkProvider: NetworkServiceType
    private let pushOrPopViewController = PassthroughSubject<Int, Never>()
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
        let finishButtonTapped: AnyPublisher<String, Never>
    }
    
    struct Output {
        let pushOrPopViewController: PassthroughSubject<Int, Never>
        let isEnable: PassthroughSubject<Bool, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.backButtonTapped
            .sink { _ in
                self.pushOrPopViewController.send(0)
            }
            .store(in: self.cancelBag)
        
        input.duplicationCheckButtonTapped
            .sink { value in
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
                // 회원가입 서버통신
                Task {
                    do {
                        let statusCode = try await self.patchUserInfoAPI(nickname: value)?.status
                        if statusCode == 200 {
                            self.pushOrPopViewController.send(1)
                        }
                    } catch {
                        print(error)
                    }
                }
                            }
            .store(in: self.cancelBag)
        
        return Output(pushOrPopViewController: pushOrPopViewController,
                      isEnable: isNotDuplicated)
    }
}

// MARK: - Network

extension JoinProfileViewModel {
    private func getNicknameDuplicationAPI(nickname: String) async throws -> BaseResponse<EmptyResponse>? {
        do {
            guard let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") else { return nil }
            let data: BaseResponse<EmptyResponse>? = try await self.networkProvider.donNetwork(
                type: .get,
                baseURL: Config.baseURL + "/nickname-validation",
                accessToken: accessToken,
                body: EmptyBody(),
                pathVariables: ["nickname":nickname])
            print ("👻👻👻👻👻닉네임 중복 체크👻👻👻👻👻")
            return data
        } catch {
           return nil
       }
    }
    
    private func patchUserInfoAPI(nickname: String) async throws -> BaseResponse<EmptyResponse>? {
        do {
            let requestDTO = UserProfileRequestDTO(nickname: nickname, is_alarm_allowed: true, member_intro: "", profile_url: StringLiterals.Network.baseImageURL)

            guard let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") else { return nil }
            let data: BaseResponse<EmptyResponse>? = try await self.networkProvider.donNetwork(
                type: .patch,
                baseURL: Config.baseURL + "/user-profile",
                accessToken: accessToken,
                body: requestDTO,
                pathVariables: ["":""])
            
            print ("👻👻👻👻👻회원가입 완료👻👻👻👻👻")
            return data
        } catch {
           return nil
       }
    }
}

