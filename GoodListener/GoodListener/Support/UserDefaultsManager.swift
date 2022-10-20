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
    case nickname
    case gender
    case age
    case job
    case description
    case snsKind
    case fcmToken
    case profileImg
    case userType
    
    // 로그인 관련 정보
    case appleID
    case isLogin
    case isGuest
    
    // Push
    case pushCnt
    
    // 나의 리스너 정보
    case listenerName
    case listenerGender
    case listenerAge
    case listenerJob
    case listenerDescription
    case listenerId
    case speakerId
    case listenerProfileImage
    
    // 만남 시간
    case channelId
    case channel
    case schedule
    case meetingTime
    case meetingDate
    
    // 전화
    case callCount
}

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    func logout() {
        self.isLogin = false
        self.accessToken = ""
        self.nickname = ""
        self.gender = ""
        self.age = ""
        self.job = ""
        self.description = "안녕하세요 굿 리스너입니다."
        self.snsKind = ""
        self.profileImg = 0
        self.isGuest = false
    }
    
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
    
    var nickname: String? {
        get {
            guard let nickname = UserDefaults.standard.value(forKey: UserDefaultKey.nickname.rawValue) as? String else {
                return "리스너"
            }
            return nickname
        }
        
        set(nickname) {
            UserDefaults.standard.set(nickname, forKey:  UserDefaultKey.nickname.rawValue)
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
                return "10"
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
    
    var description: String? {
        get {
            guard let description = UserDefaults.standard.value(forKey: UserDefaultKey.description.rawValue) as? String else {
                return "안녕하세요 굿 리스너입니다."
            }
            return description
        }
        
        set(description) {
            UserDefaults.standard.set(description, forKey:  UserDefaultKey.description.rawValue)
        }
    }
    
    var snsKind: String {
        get {
            guard let snsKind = UserDefaults.standard.value(forKey: UserDefaultKey.snsKind.rawValue) as? String else {
                return ""
            }
            return snsKind
        }
        
        set(snsKind) {
            UserDefaults.standard.set(snsKind, forKey:  UserDefaultKey.snsKind.rawValue)
        }
    }
    
    var fcmToken: String {
        get {
            guard let fcmToken = UserDefaults.standard.value(forKey: UserDefaultKey.fcmToken.rawValue) as? String else {
                return ""
            }
            return fcmToken
        }
        
        set(fcmToken) {
            UserDefaults.standard.set(fcmToken, forKey:  UserDefaultKey.fcmToken.rawValue)
        }
    }
    
    var profileImg: Int {
        get {
            guard let profileImg = UserDefaults.standard.value(forKey: UserDefaultKey.profileImg.rawValue) as? Int else {
                return 0
            }
            return profileImg
        }
        
        set(profileImg) {
            UserDefaults.standard.set(profileImg, forKey:  UserDefaultKey.profileImg.rawValue)
        }
    }
    
    var userType : String {
        get {
            guard let userType = UserDefaults.standard.value(forKey: UserDefaultKey.userType.rawValue) as? String else {
                return "speaker"
            }
            return userType
        }
        
        set(userType) {
            UserDefaults.standard.set(userType, forKey:  UserDefaultKey.userType.rawValue)
        }
    }
    
    var appleID : String? {
        get {
            guard let appleID = UserDefaults.standard.value(forKey: UserDefaultKey.appleID.rawValue) as? String else {
                return nil
            }
            return appleID
        }
        
        set(appleID) {
            UserDefaults.standard.set(appleID, forKey:  UserDefaultKey.appleID.rawValue)
        }
    }
    
    var isLogin : Bool? {
        get {
            guard let isLogin = UserDefaults.standard.value(forKey: UserDefaultKey.isLogin.rawValue) as? Bool? else {
                return false
            }
            return isLogin
        }
        
        set(isLogin) {
            UserDefaults.standard.set(isLogin, forKey:  UserDefaultKey.isLogin.rawValue)
        }
    }
    
    var isGuest : Bool {
        get {
            guard let isGuest = UserDefaults.standard.value(forKey: UserDefaultKey.isGuest.rawValue) as? Bool else {
                return false
            }
            return isGuest
        }
        
        set(isGuest) {
            UserDefaults.standard.set(isGuest, forKey:  UserDefaultKey.isGuest.rawValue)
        }
    }
    
    var pushCnt: Int {
        get {
            guard let pushCnt = UserDefaults.standard.value(forKey: UserDefaultKey.pushCnt.rawValue) as? Int else {
                return 0
            }
            return pushCnt
        }
        
        set(pushCnt) {
            UserDefaults.standard.set(pushCnt, forKey:  UserDefaultKey.pushCnt.rawValue)
        }
    }
    
    //리스너
    var channel: String {
        get {
            guard let channel = UserDefaults.standard.value(forKey: UserDefaultKey.channel.rawValue) as? String else {return ""}
            return channel
        }
        
        set(channel) {
            UserDefaults.standard.set(channel, forKey: UserDefaultKey.channel.rawValue)
        }
    }
    
    
    
    var listenerName: String {
        get {
            guard let listnerName = UserDefaults.standard.value(forKey: UserDefaultKey.listenerName.rawValue) as? String else {return ""}
            return listnerName
        }
        
        set(listenerName) {
            UserDefaults.standard.set(listenerName, forKey: UserDefaultKey.listenerName.rawValue)
        }
    }
    
    var listenerGender: String {
        get {
            guard let listenerGender = UserDefaults.standard.value(forKey: UserDefaultKey.listenerGender.rawValue) as? String else {return ""}
            return listenerGender
        }
        
        set(listenerGender) {
            UserDefaults.standard.set(listenerGender, forKey: UserDefaultKey.listenerGender.rawValue)
        }
    }
    
    var listenerAge: String {
        get {
            guard let listnerAge = UserDefaults.standard.value(forKey: UserDefaultKey.listenerAge.rawValue) as? String else {return ""}
            return listnerAge
        }
        
        set(listenerAge) {
            UserDefaults.standard.set(listenerAge, forKey: UserDefaultKey.listenerAge.rawValue)
        }
    }
    
    var listenerJob: String {
        get {
            guard let listnerJob = UserDefaults.standard.value(forKey: UserDefaultKey.listenerJob.rawValue) as? String else {return ""}
            return listnerJob
        }
        
        set(listenerJob) {
            UserDefaults.standard.set(listenerJob, forKey: UserDefaultKey.listenerJob.rawValue)
        }
    }
    
    var listenerDescription: String {
        get {
            guard let listenerDescription = UserDefaults.standard.value(forKey: UserDefaultKey.listenerDescription.rawValue) as? String else {return ""}
            return listenerDescription
        }
        
        set(listenerDescription) {
            UserDefaults.standard.set(listenerDescription, forKey: UserDefaultKey.listenerDescription.rawValue)
        }
    }
    
    var schedule: String {
        get {
            guard let schedule = UserDefaults.standard.value(forKey: UserDefaultKey.schedule.rawValue) as? String else {return ""}
            return schedule
        }
        
        set(schedule) {
            UserDefaults.standard.set(schedule, forKey: UserDefaultKey.schedule.rawValue)
        }
    }
    
    
    var meetingTime: String {
        get {
            guard let meetingTime = UserDefaults.standard.value(forKey: UserDefaultKey.meetingTime.rawValue) as? String else {return ""}
            return meetingTime
        }
        
        set(meetingTime) {
            UserDefaults.standard.set(meetingTime, forKey: UserDefaultKey.meetingTime.rawValue)
        }
    }
    
    var meetingDate: String {
        get {
            guard let meetingDate = UserDefaults.standard.value(forKey: UserDefaultKey.meetingDate.rawValue) as? String else {return ""}
            return meetingDate
        }
        
        set(meetingDate) {
            UserDefaults.standard.set(meetingDate, forKey: UserDefaultKey.meetingDate.rawValue)
        }
    }
    
    // MARK: AppGroup을 통해 추가한 데이터라 복붙하시면 안됩니다!!
    var pushData: [String] {
        get {
            guard let pushData = UserDefaults(suiteName: "group.com.heelpass.good-listener")?.value(forKey: "pushData") as? [String] else {
                return []
            }
            return pushData
        }
    }
    
    var callCount: Int {
        get {
            guard let callCount = UserDefaults.standard.value(forKey: UserDefaultKey.callCount.rawValue) as? Int else {
                return 0
            }
            return callCount
        }
        
        set(callCount) {
            UserDefaults.standard.set(callCount, forKey:  UserDefaultKey.callCount.rawValue)
        }
    }
    
    var listenerId: Int {
        get {
            guard let listenerId = UserDefaults.standard.value(forKey: UserDefaultKey.listenerId.rawValue) as? Int else {
                return 0
            }
            return listenerId
        }
        
        set(listenerId) {
            UserDefaults.standard.set(listenerId, forKey:  UserDefaultKey.listenerId.rawValue)
        }
    }
    
    var speakerId: Int {
        get {
            guard let speakerId = UserDefaults.standard.value(forKey: UserDefaultKey.speakerId.rawValue) as? Int else {
                return 0
            }
            return speakerId
        }
        
        set(speakerId) {
            UserDefaults.standard.set(speakerId, forKey:  UserDefaultKey.speakerId.rawValue)
        }
    }
    
    var channelId: Int {
        get {
            guard let channelId = UserDefaults.standard.value(forKey: UserDefaultKey.channelId.rawValue) as? Int else {
                return 0
            }
            return channelId
        }
        
        set(channelId) {
            UserDefaults.standard.set(channelId, forKey:  UserDefaultKey.channelId.rawValue)
        }
    }
    
    var listenerProfileImage: Int {
        get {
            guard let listenerProfileImage = UserDefaults.standard.value(forKey: UserDefaultKey.listenerProfileImage.rawValue) as? Int else {
                return 0
            }
            return listenerProfileImage
        }
        
        set(listenerProfileImage) {
            UserDefaults.standard.set(listenerProfileImage, forKey:  UserDefaultKey.listenerProfileImage.rawValue)
        }
    }
}
