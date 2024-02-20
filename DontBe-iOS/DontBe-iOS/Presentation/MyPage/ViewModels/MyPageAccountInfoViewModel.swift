//
//  MyPageAccountInfoViewModel.swift
//  DontBe-iOS
//
//  Created by 변상우 on 2/18/24.
//

import Combine
import Foundation

final class MyPageAccountInfoViewModel: ViewModelType {
    private let cancelBag = CancelBag()
    private let networkProvider: NetworkServiceType
    
    private var getAccountInfoData = PassthroughSubject<Void, Never>()
    private let isSignOutResult = PassthroughSubject<Int, Never>()
    
    var myPageMemberData: [String] = []
    
    struct Input {
        let viewAppear: AnyPublisher<Void, Never>
        let signOutButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let getAccountInfoData: PassthroughSubject<Void, Never>
        let isSignOutResult: PassthroughSubject<Int, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.viewAppear
            .sink { _ in
                Task {
                    do {
                        if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                            let result = try await self.getMyPageMemberDataAPI(accessToken: accessToken)
                            if let data = result?.data {
                                self.myPageMemberData = [data.socialPlatform, data.versionInformation, data.showMemberId ?? "money_rain_is_coming", data.joinDate]
                                self.getAccountInfoData.send()
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: self.cancelBag)
        
        input.signOutButtonTapped
            .sink { _ in
                Task {
                    do {
                        if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                            if let result = try await self.deleteMemberAPI(accessToken: accessToken) {
                                self.isSignOutResult.send(result.status)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: cancelBag)
        
        return Output(getAccountInfoData: getAccountInfoData,
                      isSignOutResult: isSignOutResult)
    }
    
    init(networkProvider: NetworkServiceType) {
        self.networkProvider = networkProvider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageAccountInfoViewModel {
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
    
    private func deleteMemberAPI(accessToken: String) async throws -> BaseResponse<[EmptyResponse]>? {
        do {
            let result: BaseResponse<[EmptyResponse]>? = try await self.networkProvider.donNetwork(
                type: .delete,
                baseURL: Config.baseURL + "/test-withdrawal",
                accessToken: accessToken,
                body: EmptyBody(),
                pathVariables:["":""])
            return result
        } catch {
            return nil
        }
    }
}
