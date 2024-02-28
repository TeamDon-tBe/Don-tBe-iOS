//
//  MyPageSignOutReasonViewModel.swift
//  DontBe-iOS
//
//  Created by 변상우 on 2/28/24.
//

import Combine
import Foundation

final class MyPageSignOutReasonViewModel: ViewModelType {
    private let cancelBag = CancelBag()
    private let networkProvider: NetworkServiceType
    
    private let clickedRadioButtonState = PassthroughSubject<Int, Never>()
    
    private var isFirstReasonChecked = false
    private var isSecondReasonChecked = false
    private var isThirdReasonChecked = false
    private var isFourthReasonChecked = false
    private var isFifthReasonChecked = false
    private var isSixthReasonChecked = false
    private var isSeventhReasonChecked = false
    
    struct Input {
        let firstReasonButtonTapped: AnyPublisher<Void, Never>?
        let secondReasonButtonTapped: AnyPublisher<Void, Never>?
        let thirdReasonButtonTapped: AnyPublisher<Void, Never>?
        let fourthReasonButtonTapped: AnyPublisher<Void, Never>?
        let fifthReasonButtonTapped: AnyPublisher<Void, Never>?
        let sixthReasonButtonTapped: AnyPublisher<Void, Never>?
        let seventhReasonButtonTapped: AnyPublisher<Void, Never>?
    }
    
    struct Output {
        let clickedButtonState: PassthroughSubject<Int, Never>
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        input.firstReasonButtonTapped?
            .sink { [weak self] _ in
                self?.isFirstReasonChecked.toggle()
                self?.clickedRadioButtonState.send(1)
            }
            .store(in: cancelBag)
        
        input.secondReasonButtonTapped?
            .sink { [weak self] _ in
                self?.isSecondReasonChecked.toggle()
                self?.clickedRadioButtonState.send(2)
            }
            .store(in: cancelBag)
        
        input.thirdReasonButtonTapped?
            .sink { [weak self] _ in
                self?.isThirdReasonChecked.toggle()
                self?.clickedRadioButtonState.send(3)
            }
            .store(in: cancelBag)
        
        input.fourthReasonButtonTapped?
            .sink { [weak self] _ in
                self?.isFourthReasonChecked.toggle()
                self?.clickedRadioButtonState.send(4)
            }
            .store(in: cancelBag)
        
        input.fifthReasonButtonTapped?
            .sink { [weak self] _ in
                self?.isFifthReasonChecked.toggle()
                self?.clickedRadioButtonState.send(5)
            }
            .store(in: cancelBag)
        
        input.sixthReasonButtonTapped?
            .sink { [weak self] _ in
                self?.isSixthReasonChecked.toggle()
                self?.clickedRadioButtonState.send(6)
            }
            .store(in: cancelBag)
        
        input.seventhReasonButtonTapped?
            .sink { [weak self] _ in
                self?.isSeventhReasonChecked.toggle()
                self?.clickedRadioButtonState.send(7)
            }
            .store(in: cancelBag)
        
        return Output(clickedButtonState: clickedRadioButtonState)
    }
    
    init(networkProvider: NetworkServiceType) {
        self.networkProvider = networkProvider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
