//
//  Config.swift
//  DontBe
//
//  Created by 변상우 on 12/26/23.
//

import Foundation

enum Config {
    enum Keys {
        enum Plist {
            static let nativeAppKey = "NATIVE_APP_KEY"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dictionary = Bundle.main.infoDictionary else {
            fatalError("plist cannot found.")
        }
        return dictionary
    }()
}
