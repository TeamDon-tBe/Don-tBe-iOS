//
//  AppStoreCheckManager.swift
//  DontBe-iOS
//
//  Created by yeonsu on 4/24/24.
//

import UIKit

class AppStoreCheckManager {
    
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    static let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/6475622329"
    
    func latestVersion(completion: @escaping (String?) -> Void) {
        let appleID = "6475622329"
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(appleID)") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results[0]["version"] as? String else {
                completion(nil)
                return
            }
            
            completion(appStoreVersion)
        }.resume()
    }
    
    func openAppStore() {
        guard let url = URL(string: AppStoreCheckManager.appStoreOpenUrlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
