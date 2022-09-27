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
    var profileImg: Int
    var description: String
    var fcmHash: String
    var createdAt: String
    var updatedAt: String
    var wantImg: Int
    var kind: Kind
    
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
        case wantImg
        case kind
    }
    
    init(from decoder: Decoder) throws {
        let container    = try decoder.container(keyedBy: CodingKeys.self)
        self.id          = (try? container.decode(Int.self, forKey: .id)) ?? 1
        self.snsHash     = (try? container.decode(String.self, forKey: .snsHash)) ?? ""
        self.snsKind     = (try? container.decode(String.self, forKey: .snsKind)) ?? ""
        self.email       = (try? container.decode(String.self, forKey: .email)) ?? ""
        self.nickname    = (try? container.decode(String.self, forKey: .nickname)) ?? ""
        self.gender      = (try? container.decode(String.self, forKey: .gender)) ?? ""
        self.ageRange    = (try? container.decode(String.self, forKey: .ageRange)) ?? ""
        self.job         = (try? container.decode(String.self, forKey: .job)) ?? ""
        self.profileImg  = (try? container.decode(Int.self, forKey: .profileImg)) ?? 1
        self.description = (try? container.decode(String.self, forKey: .description)) ?? ""
        self.fcmHash     = (try? container.decode(String.self, forKey: .fcmHash)) ?? ""
        self.createdAt   = (try? container.decode(String.self, forKey: .createdAt)) ?? ""
        self.updatedAt   = (try? container.decode(String.self, forKey: .updatedAt)) ?? ""
        self.wantImg     = (try? container.decode(Int.self, forKey: .wantImg)) ?? 1
        self.kind        = try container.decode(Kind.self, forKey: .kind)
    }
}

struct Kind: Codable {
    var updatedAt: String
    var type: String
    var id: Int
    var createAt: String
    
    enum CodingKeys: String, CodingKey {
        case updatedAt
        case type
        case id
        case createAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.updatedAt = (try? container.decode(String.self, forKey: .updatedAt)) ?? ""
        self.type     = (try? container.decode(String.self, forKey: .type)) ?? "speaker"
        self.id       = (try? container.decode(Int.self, forKey: .id)) ?? 1
        self.createAt = (try? container.decode(String.self, forKey: .createAt)) ?? ""
    }
}
