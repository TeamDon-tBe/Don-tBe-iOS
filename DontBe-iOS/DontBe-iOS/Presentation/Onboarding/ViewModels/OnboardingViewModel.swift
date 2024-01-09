//
//  OnboardingViewModel.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/9/24.
//

import Combine
import Foundation

final class OnboardingViewModel: ViewModelType {
    private let cancelBag = CancelBag()
    
    struct Input {
        let nextButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let voidPublisher: PassthroughSubject<Void, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let voidPublisher = PassthroughSubject<Void, Never>()
        
        input.nextButtonTapped
            .sink { _ in
                voidPublisher.send()
            }
            .store(in: self.cancelBag)
        
        return Output(voidPublisher: voidPublisher)
    }
}
