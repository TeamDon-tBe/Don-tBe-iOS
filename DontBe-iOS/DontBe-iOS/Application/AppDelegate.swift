//
//  AppDelegate.swift
//  DontBe
//
//  Created by 변상우 on 12/26/23.
//

import UIKit

import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 네비게이션 바 타이틀 텍스트 속성 설정
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.font(.body1),
            NSAttributedString.Key.foregroundColor: UIColor.donBlack
        ]
        
        KakaoSDK.initSDK(appKey: Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.nativeAppKey) as? String ?? "")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

