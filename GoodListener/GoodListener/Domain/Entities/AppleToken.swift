//
//  AppleToken.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/31.
//

import Foundation

struct AppleToken: Codable {
    var token: String
    var isExistUser: Bool
    
    enum Codingkeys: String, CodingKey {
        case token
        case isExistUser
    }
}
