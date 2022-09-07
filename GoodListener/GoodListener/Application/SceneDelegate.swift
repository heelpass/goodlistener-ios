//
//  SceneDelegate.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/07/24.
//

import UIKit
import RxKakaoSDKAuth
import KakaoSDKAuth
import AuthenticationServices
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        coordinator = AppCoordinator(navigationController: navigationController)
        coordinator?.start()
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        if UIApplication.shared.applicationIconBadgeNumber != 0 {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        savePushData()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func dateConverter()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: Date())
    }
    
    public func savePushData() {
        if let userDefault = UserDefaults(suiteName: "group.com.heelpass.good-listener") {
            if let pushData = userDefault.value(forKey: "pushData") as? [String] {
                
                pushData.forEach { pushType in
                    let pushModel = PushModel()
                    
                    // PushModel PK값 지정
                    pushModel.id = UserDefaultsManager.shared.pushCnt + 1
                    UserDefaultsManager.shared.pushCnt = pushModel.id
                    pushModel.date = dateConverter()
                    // PushModel 나머지 value 지정
                    switch pushType {
                    case "call":
                        pushModel.title = "굿리스너 통화 안내"
                        pushModel.body = "[스피커닉네임]님이 통화가 걸었어요~"
                    case "cancel":
                        pushModel.title = "굿리스너 취소 안내"
                        pushModel.body = "[스피커닉네임]님이 통화가 취소됐어요"
                    case "remain5":
                        pushModel.title = "굿리스너 통화 안내"
                        pushModel.body = "5분뒤 [스피커닉네임]과 통화 예정이에요"
                    default:
                        break
                    }
                    
                    // realm DB에 저장
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(pushModel)
                    }
                }

                userDefault.set(nil, forKey: "pushData")
            }
        }
    }
    
}

