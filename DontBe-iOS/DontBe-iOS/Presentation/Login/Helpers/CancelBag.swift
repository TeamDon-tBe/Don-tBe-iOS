//
//  CancelBag.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/8/24.
//

import Combine
import Foundation

class CancelBag {
    var subscriptions = Set<AnyCancellable>()
    
    func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    init() {}
}

extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
