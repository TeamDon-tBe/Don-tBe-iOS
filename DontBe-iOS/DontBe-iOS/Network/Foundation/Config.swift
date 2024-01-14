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
            static let baseURL = "BASE_URL"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dictionary = Bundle.main.infoDictionary else {
            fatalError("plist cannot found.")
        }
        return dictionary
    }()
}

extension Config {
    static let nativeAppKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.nativeAppKey] as? String else {
            fatalError("Base URL is not set in plist for this configuration")
        }
        return key
    }()
    
    static let baseURL: String = {
        guard let key = Config.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("Base URL is not set in plist for this configuration")
        }
        return key
    }()
}
