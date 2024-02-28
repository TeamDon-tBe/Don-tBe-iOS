//
//  JoinProfileViewModel.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/11/24.
//

import Combine
import Foundation
import UIKit

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
        let finishButtonTapped: AnyPublisher<EditUserProfileRequestDTO, Never>
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
                // 회원가입 서버통신
                Task {
                    self.patchUserInfoDataAPI(nickname: value.nickname,
                                              isAlarmAllowed: value.is_alarm_allowed,
                                              memberIntro: value.member_intro,
                                              profileImage: value.profile_image)
                    
                    self.pushOrPopViewController.send(1)
                }
                saveUserData(UserInfo(isSocialLogined: true,
                                      isFirstUser: true,
                                      isJoinedApp: true,
                                      isOnboardingFinished: false,
                                      userNickname: value.nickname,
                                      memberId: loadUserData()?.memberId ?? 0,
                                      userProfileImage: loadUserData()?.userProfileImage ?? StringLiterals.Network.baseImageURL))
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
    
    func patchUserInfoDataAPI(nickname: String, isAlarmAllowed: Bool, memberIntro: String, profileImage: UIImage) {
        guard let url = URL(string: Config.baseURL + "/user-profile2") else { return }
        guard let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") else { return }
        
        let imageData = profileImage.jpegData(compressionQuality: 0.5)!
        
        let parameters: [String: Any] = [
            "nickname": nickname,
            "isAlarmAllowed": isAlarmAllowed,
            "memberIntro": memberIntro
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        // Multipart form data 생성
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        var requestBodyData = Data()
        
        // 프로필 정보 추가
        requestBodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        requestBodyData.append("Content-Disposition: form-data; name=\"info\"\r\n\r\n".data(using: .utf8)!)
        requestBodyData.append(try! JSONSerialization.data(withJSONObject: parameters, options: []))
        requestBodyData.append("\r\n".data(using: .utf8)!)
        
        // 프로필 이미지 데이터 추가
        requestBodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        requestBodyData.append("Content-Disposition: form-data; name=\"file\"; filename=\"dontbe.jpeg\"\r\n".data(using: .utf8)!)
        requestBodyData.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        requestBodyData.append(imageData)
        requestBodyData.append("\r\n".data(using: .utf8)!)
        
        requestBodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // HTTP body에 데이터 설정
        request.httpBody = requestBodyData
        
        // URLSession으로 요청 보내기
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error:", error)
                return
            }
            
            // 응답 처리
            if let response = response as? HTTPURLResponse {
                print(response)
                print("Response status code:", response.statusCode)
            }
            
            if let data = data {
                // 서버 응답 데이터 처리
                print("Response data:", String(data: data, encoding: .utf8) ?? "Empty response")
            }
        }
        task.resume()
    }
}

