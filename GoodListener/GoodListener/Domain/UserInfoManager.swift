//
//  UserInfoManager.swift
//  GoodListener
//
//  Created by cheonsong on 2022/09/27.
//

import Foundation

struct UserInfoManager {
    static var shared = UserInfoManager()
    
    var userInfo: UserInfo!
    
    private init() { }
}
