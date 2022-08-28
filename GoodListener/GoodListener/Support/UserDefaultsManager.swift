//
//  UserDefaultManager.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/17.
//

import Foundation

enum UserDefaultKey : String {
    case accessToken
    
    // 유저 정보
    case name
    case gender
    case age
    case job
    case introduce
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
    
    var name: String? {
        get {
            guard let name = UserDefaults.standard.value(forKey: UserDefaultKey.name.rawValue) as? String else {
                return "리스너"
            }
            return name
        }
        
        set(name) {
            UserDefaults.standard.set(name, forKey:  UserDefaultKey.name.rawValue)
        }
    }
    
    var gender: String? {
        get {
            guard let gender = UserDefaults.standard.value(forKey: UserDefaultKey.gender.rawValue) as? String else {
                return "male"
            }
            return gender
        }
        
        set(gender) {
            UserDefaults.standard.set(gender, forKey:  UserDefaultKey.gender.rawValue)
        }
    }
    
    var age: String? {
        get {
            guard let age = UserDefaults.standard.value(forKey: UserDefaultKey.age.rawValue) as? String else {
                return "age10"
            }
            return age
        }
        
        set(age) {
            UserDefaults.standard.set(age, forKey:  UserDefaultKey.age.rawValue)
        }
    }
    
    var job: String? {
        get {
            guard let job = UserDefaults.standard.value(forKey: UserDefaultKey.job.rawValue) as? String else {
                return "student"
            }
            return job
        }
        
        set(job) {
            UserDefaults.standard.set(job, forKey:  UserDefaultKey.job.rawValue)
        }
    }
    
    var introduce: String? {
        get {
            guard let introduce = UserDefaults.standard.value(forKey: UserDefaultKey.introduce.rawValue) as? String else {
                return "안녕하세요 굿 리스너입니다."
            }
            return introduce
        }
        
        set(introduce) {
            UserDefaults.standard.set(introduce, forKey:  UserDefaultKey.introduce.rawValue)
        }
    }
}

