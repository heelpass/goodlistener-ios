//
//  NotificationService.swift
//  NotificationService
//
//  Created by cheonsong on 2022/09/07.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            if let userInfo = request.content.userInfo as? [String: Any] {
                if let userDefault = UserDefaults(suiteName: "group.com.heelpass.good-listener"){
                    
                    // 앱이 실행되기 전까지 푸쉬를 배열로 저장한다
                    // SceneDelegate에서 저장된 데이터를 기반으로 구현
                    var pushData = (userDefault.value(forKey: "pushData") as? [String]) ?? []
                    
                    pushData.append(userInfo["flag"] as! String)
                    
                    
                    userDefault.set(pushData, forKey: "pushData")
                    userDefault.synchronize()
                }
            }
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}
