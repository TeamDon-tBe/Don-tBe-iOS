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
    
    private let popViewController = PassthroughSubject<Void, Never>()
    private let allButtonChecked = PassthroughSubject<Bool, Never>()
    private let isEnabled = PassthroughSubject<Int, Never>()
    private let clickedButtonState = PassthroughSubject<(Int, Bool), Never>()
    private let pushViewController = PassthroughSubject<Void, Never>()

    private var isAllChecked = false
    private var isFirstChecked = false
    private var isSecondChecked = false
    private var isThirdChecked = false
    private var isFourthChecked = false
    
    struct Input {
        let backButtonTapped: AnyPublisher<Void, Never>
        let allCheckButtonTapped: AnyPublisher<Void, Never>
        let firstCheckButtonTapped: AnyPublisher<Void, Never>
        let secondCheckButtonTapped: AnyPublisher<Void, Never>
        let thirdCheckButtonTapped: AnyPublisher<Void, Never>
        let fourthCheckButtonTapped: AnyPublisher<Void, Never>
        let nextButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let popViewController: PassthroughSubject<Void, Never>
        let isAllcheck: PassthroughSubject<Bool, Never>
        let isEnable: PassthroughSubject<Int, Never>
        let clickedButtonState: PassthroughSubject<(Int, Bool), Never>
        let pushViewController: PassthroughSubject<Void, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.allCheckButtonTapped
            .sink { [weak self] _ in
                // 모든 버튼 상태를 업데이트하고 신호를 보냄
                self?.isAllChecked.toggle()
                self?.isFirstChecked = self?.isAllChecked ?? false
                self?.isSecondChecked = self?.isAllChecked ?? false
                self?.isThirdChecked = self?.isAllChecked ?? false
                self?.isFourthChecked = self?.isAllChecked ?? false
                self?.isEnabled.send(self?.isNextButtonEnabled() ?? 0)
                self?.allButtonChecked.send(self?.isAllChecked ?? false)
            }
            .store(in: cancelBag)
        
        input.firstCheckButtonTapped
            .sink { [weak self] _ in
                // 첫 번째 버튼 상태를 업데이트하고 신호를 보냄
                self?.isFirstChecked.toggle()
                self?.clickedButtonState.send((1, self?.isFirstChecked ?? false))
                self?.isEnabled.send(self?.isNextButtonEnabled() ?? 0)
            }
            .store(in: cancelBag)
        
        input.secondCheckButtonTapped
            .sink { [weak self] _ in
                // 두 번째 버튼 상태를 업데이트하고 신호를 보냄
                self?.isSecondChecked.toggle()
                self?.clickedButtonState.send((2, self?.isSecondChecked ?? false))
                self?.isEnabled.send(self?.isNextButtonEnabled() ?? 0)
            }
            .store(in: cancelBag)
        
        input.thirdCheckButtonTapped
            .sink { [weak self] _ in
                // 세 번째 버튼 상태를 업데이트하고 신호를 보냄
                self?.isThirdChecked.toggle()
                self?.clickedButtonState.send((3, self?.isThirdChecked ?? false))
                self?.isEnabled.send(self?.isNextButtonEnabled() ?? 0)
            }
            .store(in: cancelBag)
        
        input.fourthCheckButtonTapped
            .sink { [weak self] _ in
                // 네 번째 버튼 상태를 업데이트하고 신호를 보냄
                self?.isFourthChecked.toggle()
                self?.clickedButtonState.send((4, self?.isFourthChecked ?? false))
                self?.isEnabled.send(self?.isNextButtonEnabled() ?? 0)
            }
            .store(in: cancelBag)
        
        
        input.backButtonTapped
            .sink { _ in
                self.popViewController.send()
            }
            .store(in: cancelBag)
        
        input.nextButtonTapped
            .sink { _ in
                self.pushViewController.send()
            }
            .store(in: cancelBag)
        
        return Output(popViewController: popViewController,
                      isAllcheck: allButtonChecked,
                      isEnable: isEnabled,
                      clickedButtonState: clickedButtonState, 
                      pushViewController: pushViewController)
    }
    
    private func isNextButtonEnabled() -> Int {
        let necessaryCheckCount = 3
        let allCheckCount = 4
        
        let necessaryCheckedCount = [isFirstChecked, isSecondChecked, isThirdChecked].filter { $0 }.count
        let allCheckedCount = [isFirstChecked, isSecondChecked, isThirdChecked, isFourthChecked].filter { $0 }.count
                
        if allCheckedCount == allCheckCount {
            return 0
        } else if necessaryCheckedCount >= necessaryCheckCount {
            return 1
        } else {
            return 2
        }
    }
}
