//
//  NotificationViewModel.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/12/24.
//

import Combine
import Foundation

final class NotificationViewModel: ViewModelType {
    
    private let cancelBag = CancelBag()
    private let reloadTableView = PassthroughSubject<Int, Never>()
    var notificationList: [NotificationList?] = []
    private let networkProvider: NetworkServiceType
    
    init(networkProvider: NetworkServiceType) {
        self.networkProvider = networkProvider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct Input {
        let viewLoad: AnyPublisher<Void, Never>
        let refreshControlClicked: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let reloadTableView: PassthroughSubject<Int, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.viewLoad
            .sink { _ in
                // viewDidLoad -> 서버통신
                Task {
                    let data = try await self.getNotificationListAPI()
                    let myNotiList = data?.data.map { data -> NotificationList in
                        guard let notificationType = NotificaitonType(rawValue: data.notificationTriggerType)
                        else { return NotificationList.baseList }
                        return NotificationList(
                            memberNickname: data.memberNickname,
                            triggerMemberNickname: data.triggerMemberNickname,
                            triggerMemberProfileUrl: data.triggerMemberProfileUrl,
                            notificationTriggerId: data.notificationTriggerId,
                            notificationType: notificationType,
                            time: data.time)
                    }
                    self.notificationList = myNotiList ?? []
                    _ = try await self.patchNotificationCheck()
                    self.reloadTableView.send(0)
                }
            }
            .store(in: self.cancelBag)
        
        input.refreshControlClicked
            .sink { _ in
                // 리프레시 -> 서버통신
                Task {
                    let data = try await self.getNotificationListAPI()
                    let myNotiList = data?.data.map { data -> NotificationList in
                        guard let notificationType = NotificaitonType(rawValue: data.notificationTriggerType)
                        else { return NotificationList.baseList }
                        return NotificationList(
                            memberNickname: data.memberNickname,
                            triggerMemberNickname: data.triggerMemberNickname,
                            triggerMemberProfileUrl: data.triggerMemberProfileUrl,
                            notificationTriggerId: data.notificationTriggerId,
                            notificationType: notificationType,
                            time: data.time)
                    }
                    self.notificationList = myNotiList ?? []
                    _ = try await self.patchNotificationCheck()
                    self.reloadTableView.send(1)
                }
            }
            .store(in: self.cancelBag)
        
        return Output(reloadTableView: reloadTableView)
    }
}

extension NotificationViewModel {
    private func getNotificationListAPI() async throws -> NotificationListResponseDTO? {
        do {
            guard let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") else { return nil }
            let data: NotificationListResponseDTO? = try await self.networkProvider.donNetwork(
                type: .get,
                baseURL: Config.baseURL + "/member-notifications",
                accessToken: accessToken,
                body: EmptyBody(),
                pathVariables: ["cursor": "-1"])
            print ("👻👻👻👻👻노티 리스트 조회👻👻👻👻👻")
            return data
        } catch {
            return nil
        }
    }
    
    private func patchNotificationCheck() async throws -> BaseResponse<EmptyResponse>? {
        do {
            guard let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") else { return nil }
            let data: BaseResponse<EmptyResponse>? = try await self.networkProvider.donNetwork(
                type: .patch,
                baseURL: Config.baseURL + "/notification-check",
                accessToken: accessToken,
                body: EmptyBody(),
                pathVariables: ["": ""])
            print ("👻👻👻👻👻노티 체크 성공👻👻👻👻👻")
            return data
        } catch {
            return nil
        }
    }
}
