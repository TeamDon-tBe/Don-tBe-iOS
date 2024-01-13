//
//  NotificationViewModel.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/12/24.
//

import Combine
import Foundation

final class NotificationViewModel {
    
    private let reloadTableView = PassthroughSubject<[NotificationDummy], Never>()
    let dummy = NotificationDummy.dummy()
    
    struct Output {
        let reloadTableView: PassthroughSubject<[NotificationDummy], Never>
    }
    
    func transform() -> Output {
        // 서버통신으로 구조체 받아옴
        // self.dummy는 서버통신으로 받아온 구조체 배열로 대체
        self.reloadTableView.send(self.dummy)
      
        return Output(reloadTableView: reloadTableView)
    }
}
