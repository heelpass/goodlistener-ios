//
//  AppDelegate.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/07/24.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import AuthenticationServices
import SwiftyJSON
import Toaster
import RxSwift

struct AppState {
    static let agoraToken: PublishSubject<String> = .init()
    static let speakerIn: PublishSubject<Void> = .init()
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        // 알림 권한 창
        registerRemoteNotification()
        // 현재 등록된 Fcm토큰값 불러오는 함수
        getFCMToken()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
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
    
    private func registerRemoteNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) { granted, _ in
            // 1. APNs에 device token 등록 요청
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    private func getFCMToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                Log.d("FCM Token Error:: \(error)")
            } else if let token = token {
                Log.d("FCM 등록 토큰:: \(token)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    /// Foreground 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([])
        } else {
            // Fallback on earlier versions
            completionHandler([])
        }
        DBManager.shared.savePushData()
        
        // Foreground 상태에서 전화가 왔는데 플래그가 call 이면 바로 전화를 띄워준다
        if let userInfo = notification.request.content.userInfo as? [String: Any] {
            Log.d(userInfo)
            if userInfo["flag"] as! String == "Call" {
                if let vc = UIApplication.getMostTopViewController()?.tabBarController as? CustomTabBarController {
                    vc.coordinator?.call(model: nil)
                }
            } else if userInfo["flag"] as! String == "SpeakerIn" {
                AppState.speakerIn.onNext(())
            } else if userInfo["flag"] as! String == "AgoraToken" {
                AppState.agoraToken.onNext(userInfo["token"] as! String)
            }
        }
    }
    /// Background 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Push데이터를 받는곳!!
        Log.d("Notification didReceive")
        if let userInfo = response.notification.request.content.userInfo as? [String: Any] {
            Log.d(userInfo)
            if userInfo["flag"] as! String == "Call" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    if let vc = UIApplication.getMostTopViewController()?.tabBarController as? CustomTabBarController {
                        vc.coordinator?.call(model: nil)
                    }
                })
            }
        }
        
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM 토큰 갱신: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        guard let _ = UserDefaultsManager.shared.accessToken else { return }
        if UserDefaultsManager.shared.fcmToken != fcmToken! {
            UserDefaultsManager.shared.fcmToken = fcmToken!
            UserAPI.updateDeviceToken(request: fcmToken!, completion: { (result, error) in
                guard let _ = result else {
                    Log.e(error ?? #function)
                    return
                }
            })
        }
    }
}
