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
    private let popViewController = PassthroughSubject<Void, Never>()
    
    struct Input {
        let backButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let popViewController: PassthroughSubject<Void, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.backButtonTapped
            .sink { _ in
                self.popViewController.send()
            }
            .store(in: self.cancelBag)
        return Output(popViewController: popViewController)
    }
}
