//
//  MyPageProfileViewModel.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/17/24.
//

import Combine
import Foundation
import UIKit

final class MyPageProfileViewModel: ViewModelType {
    
    private let cancelBag = CancelBag()
    private let networkProvider: NetworkServiceType
    
    private var getProfileData = PassthroughSubject<String, Never>()
    private let popViewController = PassthroughSubject<Void, Never>()
    private let isNotDuplicated = PassthroughSubject<Bool, Never>()
    
    init(networkProvider: NetworkServiceType) {
        self.networkProvider = networkProvider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    struct Input {
        let viewWillAppear: AnyPublisher<Int, Never>
        let backButtonTapped: AnyPublisher<Void, Never>
        let duplicationCheckButtonTapped: AnyPublisher<String, Never>
        let finishButtonTapped: AnyPublisher<EditUserProfileRequestDTO, Never>
    }
    
    struct Output {
        let getProfileData: PassthroughSubject<String, Never>
        let popViewController: PassthroughSubject<Void, Never>
        let isEnable: PassthroughSubject<Bool, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.viewWillAppear
            .sink { memberId in
                Task {
                    do {
                        if let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") {
                            let profileResult = try await self.getProfileInfoAPI(accessToken: accessToken, memberId: memberId)
                            if let data = profileResult?.data {
                                self.getProfileData.send(data.memberProfileUrl)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: self.cancelBag)
        
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
                    self.uploadData(nickname: value.nickname,
                                    isAlarmAllowed: value.is_alarm_allowed,
                                    memberIntro: value.member_intro,
                                    profileImage: value.profile_image)
                }
                
                saveUserData(UserInfo(isSocialLogined: true,
                                      isFirstUser: false,
                                      isJoinedApp: true,
                                      isOnboardingFinished: true,
                                      userNickname: value.nickname,
                                      memberId: loadUserData()?.memberId ?? 0,
                                      userProfileImage: loadUserData()?.userProfileImage ?? StringLiterals.Network.baseImageURL))
                
                self.popViewController.send()
            }
            .store(in: self.cancelBag)
        
        return Output(getProfileData: getProfileData,
                      popViewController: popViewController,
                      isEnable: isNotDuplicated)
    }
}

// MARK: - Network

extension MyPageProfileViewModel {
    private func getProfileInfoAPI(accessToken: String, memberId: Int) async throws -> BaseResponse<MypageProfileResponseDTO>? {
        do {
            let result: BaseResponse<MypageProfileResponseDTO>? = try await self.networkProvider.donNetwork(
                type: .get,
                baseURL: Config.baseURL + "/viewmember/\(memberId)",
                accessToken: accessToken,
                body: EmptyBody(),
                pathVariables: ["":""])
            UserDefaults.standard.set(result?.data?.memberGhost ?? 0, forKey: "memberGhost")
            return result
        } catch {
            return nil
        }
    }
    
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
    
    func uploadData(nickname: String, isAlarmAllowed: Bool, memberIntro: String, profileImage: UIImage) {
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
