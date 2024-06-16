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
import FirebaseCore
import FirebaseMessaging

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
            // KeychainWrapper에 Access Token 저장하고 소셜로그인 화면으로
            let accessToken = KeychainWrapper.loadToken(forKey: "accessToken") ?? ""
            KeychainWrapper.saveToken(accessToken, forKey: "accessToken")
            
            // KeychainWrasapper에 Refresh Token 저장하고 소셜로그인 화면으로
            let refreshToken = KeychainWrapper.loadToken(forKey: "refreshToken") ?? ""
            KeychainWrapper.saveToken(refreshToken, forKey: "refreshToken")
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        FirebaseApp.configure()

        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true

        UNUserNotificationCenter.current().delegate = self

        application.registerForRemoteNotifications()
    
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

extension AppDelegate: UNUserNotificationCenterDelegate {
    /// 푸시클릭시
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let notiInfomation = response.notification.request.content.userInfo
        if let contentID = notiInfomation["relateContentId"] as? String {
            let pushAlarmHelper = DontBePushAlarmHelper(contentID: Int(contentID) ?? 0)
                pushAlarmHelper.start()
        }
        print("🟢", #function)
    }
    
    /// 앱화면 보고있는중에 푸시올 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    /// FCMToken 업데이트시
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: dataDict
        )
        saveUserData(UserInfo(isSocialLogined: loadUserData()?.isSocialLogined ?? false,
                              isFirstUser: loadUserData()?.isFirstUser ?? false,
                              isJoinedApp: loadUserData()?.isJoinedApp ?? false,
                              isOnboardingFinished: loadUserData()?.isOnboardingFinished ?? false,
                              userNickname: loadUserData()?.userNickname ?? "",
                              memberId: loadUserData()?.memberId ?? 0,
                              userProfileImage: loadUserData()?.userProfileImage ?? StringLiterals.Network.baseImageURL,
                              fcmToken: fcmToken ?? "",
                              isPushAlarmAllowed: loadUserData()?.isPushAlarmAllowed ?? false))
        print("🟢", #function, fcmToken)
    }
    
    /// 스위즐링 NO시, APNs등록, APNs토큰값가져옴
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("🟢", #function)
    }
    
    /// error발생시
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("🟢", error)
    }
}

extension AppDelegate: MessagingDelegate {
    
}
