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
    private let pushOrPopViewController = PassthroughSubject<Int, Never>()
    private let isNotDuplicated = PassthroughSubject<Bool, Never>()
    private var isPossible: Bool = true
    
    struct Input {
        let backButtonTapped: AnyPublisher<Void, Never>
        let duplicationCheckButtonTapped: AnyPublisher<String, Never>
        let finishButtonTapped: AnyPublisher<Void, Never>
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
                print(value)
                // value(텍스트 필드의 텍스트) 가지고 서버통신 ㄱㄱ
                // 서버통신 완료되면 신호
                /* 서버통신 -> 사용불가 -> false
                          -> 사용가능 -> true 반환 */
                self.isNotDuplicated.send(self.isPossible)
            }
            .store(in: self.cancelBag)
        
        input.finishButtonTapped
            .sink { _ in
                self.pushOrPopViewController.send(1)
            }
            .store(in: self.cancelBag)
        
        return Output(pushOrPopViewController: pushOrPopViewController,
                      isEnable: isNotDuplicated)
    }
}
