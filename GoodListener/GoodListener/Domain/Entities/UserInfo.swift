//
//  UserInfo.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/18.
//

import Foundation
import UIKit

struct UserInfo: Codable {
    var id: Int
    var snsHash: String
    var snsKind: String
    var email: String
    var nickname: String
    var gender: String
    var ageRange: String
    var job: String
    var profileImg: String
    var description: String
    var fcmHash: String
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case snsHash
        case snsKind
        case email
        case nickname
        case gender
        case ageRange
        case job
        case profileImg
        case description
        case fcmHash
        case createdAt
        case updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let values   = try decoder.container(keyedBy: CodingKeys.self)
        id           = (try? values.decode(Int.self, forKey: .id)) ?? 0
        snsHash      = (try? values.decode(String.self, forKey: .snsHash)) ?? ""
        snsKind      = (try? values.decode(String.self, forKey: .snsKind)) ?? ""
        email        = (try? values.decode(String.self, forKey: .email)) ?? ""
        nickname     = (try? values.decode(String.self, forKey: .nickname)) ?? ""
        gender       = (try? values.decode(String.self, forKey: .gender)) ?? ""
        ageRange     = (try? values.decode(String.self, forKey: .ageRange)) ?? ""
        job          = (try? values.decode(String.self, forKey: .job)) ?? ""
        profileImg   = (try? values.decode(String.self, forKey: .profileImg)) ?? ""
        description  = (try? values.decode(String.self, forKey: .description)) ?? ""
        fcmHash      = (try? values.decode(String.self, forKey: .fcmHash)) ?? ""
        createdAt    = (try? values.decode(String.self, forKey: .createdAt)) ?? ""
        updatedAt    = (try? values.decode(String.self, forKey: .updatedAt)) ?? ""
    }
}
