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
    var dummy = [NotificationDummy(profile: nil, userName: "", description: "", minutes: "")]
    
    struct Input {
        let viewLoad: AnyPublisher<Void, Never>
        let refreshControlClicked: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let reloadTableView: PassthroughSubject<Int, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        // 서버통신으로 구조체 받아옴
        // self.dummy는 서버통신으로 받아온 구조체 배열로 대체
        input.viewLoad
            .sink { _ in
                self.dummy = NotificationDummy.dummy()
                self.reloadTableView.send(0)
                
            }
            .store(in: self.cancelBag)
        
        input.refreshControlClicked
            .sink { _ in
                // 리프레시 -> 서버통신
                self.dummy = NotificationDummy.dummy()
                self.reloadTableView.send(1)
            }
            .store(in: self.cancelBag)
        
        return Output(reloadTableView: reloadTableView)
    }
}
