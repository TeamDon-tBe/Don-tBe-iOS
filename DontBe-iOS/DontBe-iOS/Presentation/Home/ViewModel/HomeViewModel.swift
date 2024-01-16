//
//  HomeViewModel.swift
//  DontBe-iOS
//
//  Created by yeonsu on 1/8/24.
//

import Foundation

import Combine

final class HomeViewModel: ViewModelType {
    
    private let cancelBag = CancelBag()
    private let networkProvider: NetworkServiceType
    private var getData = PassthroughSubject<Void, Never>()
    
    var postData: [PostDataResponseDTO] = []
    
    struct Input {
        let viewUpdate: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let getData: PassthroughSubject<Void, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.viewUpdate
            .sink { [self] _ in
                Task {
                    do {
                        if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                            let result = try await
                            self.getPostDataAPI(accessToken: accessToken)
                            if let data = result?.data {
                                var tempArray: [PostDataResponseDTO] = []
                                for content in data {
                                    tempArray.append(content)
                                }
                                self.postData = tempArray
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

extension HomeViewModel {
    private func getPostDataAPI(accessToken: String) async throws -> BaseResponse<[PostDataResponseDTO]>? {
        let accessToken = accessToken
        do {
            let result: BaseResponse<[PostDataResponseDTO]>? = try
            await self.networkProvider.donNetwork(type: .get, baseURL: Config.baseURL + "/content/all", accessToken: accessToken, body: EmptyBody(), pathVariables: ["":""])
            
            if let data = result?.data {
                var tempArrayData: [PostDataResponseDTO] = []
                
                for content in data {
                    tempArrayData.append(content)
                }
                self.postData = tempArrayData
            }
            return result
        } catch {
            return nil
        }
    }
}
