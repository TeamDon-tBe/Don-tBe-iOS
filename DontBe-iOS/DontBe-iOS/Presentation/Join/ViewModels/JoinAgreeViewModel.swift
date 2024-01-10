//
//  JoinViewModel.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/10/24.
//

import Combine
import Foundation

final class JoinAgreeViewModel: ViewModelType {
    private let cancelBag = CancelBag()
    private let isAllCheckedSubject = CurrentValueSubject<Bool, Never>(false)
    
    struct Input {
        let allCheckButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let isAllChecked: AnyPublisher<Bool, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.allCheckButtonTapped
            .sink { [weak self] _ in
                self?.isAllCheckedSubject.value.toggle()
            }
            .store(in: cancelBag)
        
        return Output(isAllChecked: isAllCheckedSubject.eraseToAnyPublisher())
    }
}
