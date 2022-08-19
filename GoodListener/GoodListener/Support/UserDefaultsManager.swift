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
                return "Bearer eyJraWQiOiJZdXlYb1kiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLmhlZWxwYXNzLmdvb2QtbGlzdGVuZXIiLCJleHAiOjE2NjAyMjI3MzUsImlhdCI6MTY2MDEzNjMzNSwic3ViIjoiMDAwODU3Ljc3NThhOGQ3NDAzYTRkMWNhYzIwOTNmMDYzOWI3NGQ5LjE0NTIiLCJhdF9oYXNoIjoiUUdqTTgwUXQ4MWozTW15SndmeXlkZyIsImVtYWlsIjoieWh3cTdwZHdmdkBwcml2YXRlcmVsYXkuYXBwbGVpZC5jb20iLCJlbWFpbF92ZXJpZmllZCI6InRydWUiLCJpc19wcml2YXRlX2VtYWlsIjoidHJ1ZSIsImF1dGhfdGltZSI6MTY2MDEzNjI2MCwibm9uY2Vfc3VwcG9ydGVkIjp0cnVlfQ.UwHQq5CMd88wcyh3030cEVZEw6ZFAR5xsng0Bg4MHgaO6qWfKV60xU8Loeq_-OqdyfNoMVT9aS6hZefKmMx52Ra2ox-FSHmTfYeJFYXB5rWO8Bq--K7NyRgsWq9zAAONfdbIPP2QNaHM3w1dopqkoRR7NeoDIi-n3iOh6r6r6AD_cCo3o8lpHB8kbMqHW8e7GCojnzHJIdlCW8ETDifVbstQf8GjKdfGF6YSWoFV0RB37L9kQhbeLgOSGE2Al1H5drspGpkQSQEdyfG1oaKmiqLyl9U276a3921QwQm4-Iy9wi8utfx6HQa2eaMzIsdwF9XSjrot_aLGMwxfblEaQw"
            }
            return accessToken
        }
        
        set(accessToken) {
            UserDefaults.standard.set(accessToken, forKey:  UserDefaultKey.accessToken.rawValue)
        }
    }
}

