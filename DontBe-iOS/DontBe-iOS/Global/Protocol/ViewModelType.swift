//
//  ViewModelType.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/8/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output
}
