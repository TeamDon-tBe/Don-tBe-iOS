//
//  MyPageMemberDataViewModel.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/14/24.
//

import Combine
import Foundation

final class MyPageViewModel: ViewModelType {
    
    private let cancelBag = CancelBag()
    private let networkProvider: NetworkServiceType
    private var getData = PassthroughSubject<Void, Never>()
    private var getProfileData = PassthroughSubject<MypageProfileResponseDTO, Never>()
    
    var myPageMemberData: [String] = []
    private var memberId: Int = loadUserData()?.memberId ?? 0
    
    struct Input {
        let viewUpdate: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let getData: PassthroughSubject<Void, Never>
        let getProfileData: PassthroughSubject<MypageProfileResponseDTO, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.viewUpdate
            .sink { value in
                if value == 0 {
                    Task {
                        do {
                            if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                                let result = try await self.getMyPageMemberDataAPI(accessToken: accessToken)
                                if let data = result?.data {
                                    self.myPageMemberData = [data.socialPlatform, data.versionInformation, data.showMemberId ?? "money_rain_is_coming", data.joinDate]
                                    self.getData.send()
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                } else if value == 1 {
                    Task {
                        do {
                            if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                                let result = try await self.getProfileInfoAPI(accessToken: accessToken, memberId: "\(self.memberId)")
                                if let data = result?.data {
                                    self.getProfileData.send(data)
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            .store(in: self.cancelBag)
        
        return Output(getData: getData, getProfileData: getProfileData)
    }
    
    init(networkProvider: NetworkServiceType) {
        self.networkProvider = networkProvider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageViewModel {
    private func getMyPageMemberDataAPI(accessToken: String) async throws -> BaseResponse<MyPageMemberDataResponseDTO>? {
        do {
            let result: BaseResponse<MyPageMemberDataResponseDTO>? = try await self.networkProvider.donNetwork(
                type: .get,
                baseURL: Config.baseURL + "/member-data",
                accessToken: accessToken,
                body: EmptyBody(),
                pathVariables: ["":""])
            
            if let data = result?.data {
                let memberData = MyPageMemberDataResponseDTO(memberId: data.memberId,
                                                             joinDate: data.joinDate,
                                                             showMemberId: data.showMemberId,
                                                             socialPlatform: data.socialPlatform,
                                                             versionInformation: data.versionInformation)
            }
            return result
        } catch {
            return nil
        }
    }
    
    private func getProfileInfoAPI(accessToken: String, memberId: String) async throws -> BaseResponse<MypageProfileResponseDTO>? {
        do {
            let result: BaseResponse<MypageProfileResponseDTO>? = try await self.networkProvider.donNetwork(
                type: .get,
                baseURL: Config.baseURL + "/viewmember/\(memberId)",
                accessToken: accessToken,
                body: EmptyBody(),
                pathVariables: ["":""])
            return result
        } catch {
            return nil
        }
    }
    
}
