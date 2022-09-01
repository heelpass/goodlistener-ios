//
//  LoginModel.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/29.
//

import Foundation

struct SignInModel: Codable {
    var snsKind: String = ""
    var email: String = ""
    var nickname: String = ""
    var gender: String = ""
    var ageRange: String = ""
    var job: String = ""
    var fcmHash: String = ""
    var profileImg: Int = 1
    var description: String = ""
}
