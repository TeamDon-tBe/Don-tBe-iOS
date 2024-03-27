//
//  AppDelegate.swift
//  DontBe
//
//  Created by 변상우 on 12/26/23.
//

import AuthenticationServices
import UIKit

import Amplitude
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var window: UIWindow { (UIApplication.shared.delegate?.window!)! }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 네비게이션 바 타이틀 텍스트 속성 설정
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.font(.body1),
            NSAttributedString.Key.foregroundColor: UIColor.donBlack
        ]
        
        KakaoSDK.initSDK(appKey: Config.nativeAppKey)
        
        /// Amplitude 설정
        Amplitude.instance().initializeApiKey(Config.amplitudeAppKey)
        
        NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil, queue: nil) { (Notification) in
            // 앱 실행 중 강제로 연결 취소 시 로그인 페이지로 이동
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                DispatchQueue.main.async {
                    let rootViewController = LoginViewController(viewModel: LoginViewModel(networkProvider: NetworkService()))
                    sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: rootViewController)
                }
            }
            saveUserData(UserInfo(isSocialLogined: false,
                                  isFirstUser: false,
                                  isJoinedApp: true,
                                  isOnboardingFinished: true,
                                  userNickname: loadUserData()?.userNickname ?? "",
                                  memberId: loadUserData()?.memberId ?? 0,
                                  userProfileImage: loadUserData()?.userProfileImage ?? StringLiterals.Network.baseImageURL))
            // KeychainWrapper에 Access Token 저장하고 소셜로그인 화면으로
            let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") ?? ""
            KeychainWrapper.saveToken(accessToken, forKey: "accessToken")
            
            // KeychainWrasapper에 Refresh Token 저장하고 소셜로그인 화면으로
            let refreshToken = KeychainWrapper.loadToken(forKey: "refreshToken") ?? ""
            KeychainWrapper.saveToken(refreshToken, forKey: "refreshToken")
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
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

