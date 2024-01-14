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
    
    var myPageMemberData: [String] = []
    
    struct Input {
        let viewUpdate: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let getData: PassthroughSubject<Void, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.viewUpdate
            .sink { _ in
                Task {
                    do {
                        if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                            let result = try await self.getMyPageMemberData(accessToken: accessToken)
                            if let data = result?.data {
                                self.myPageMemberData = [data.socialPlatform, data.versionInformation, data.showMemberId ?? "money_rain_is_coming", data.joinDate]
                                self.getData.send()
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: self.cancelBag)
        
        return Output(getData: getData)
    }
    
    init(networkProvider: NetworkServiceType) {
        self.networkProvider = networkProvider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageViewModel {
    private func getMyPageMemberData(accessToken: String) async throws -> BaseResponse<MyPageMemberDataResponseDTO>? {
        let accessToken = accessToken
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
}
