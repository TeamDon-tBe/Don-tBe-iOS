//
//  OnboardingEndingViewModel.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/9/24.
//

import Combine
import Foundation

final class OnboardingEndingViewModel: ViewModelType {
    private let cancelBag = CancelBag()
    
    struct Input {
        let startButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let voidPublisher: PassthroughSubject<String, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let publisher = PassthroughSubject<String, Never>()
        
        input.startButtonTapped
            .sink { _ in
                // 온보딩 완료 서버통신
                // 서버통신 완료되면 신호
            }
            .store(in: self.cancelBag)
        
        return Output(voidPublisher: publisher)
    }
}
