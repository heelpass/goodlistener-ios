//
//  UserDefaultManager.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/17.
//

import Foundation

enum UserDefaultKey : String {
    case accessToken
}

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    // MARK: - authtoken from rest
    var accessToken : String? {
        get {
            guard let accessToken = UserDefaults.standard.value(forKey: UserDefaultKey.accessToken.rawValue) as? String else {
                return nil
            }
            return accessToken
        }
        
        set(accessToken) {
            UserDefaults.standard.set(accessToken, forKey:  UserDefaultKey.accessToken.rawValue)
        }
    }
}

