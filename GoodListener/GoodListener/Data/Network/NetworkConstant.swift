//
//  NetworkConstant.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/17.
//

import Foundation

struct ApiAddress {
    static let Host = "http://223.130.162.39:29430"
}

struct ApiURL {
    static let ServiceStart = ApiAddress.Host
    static let TokenRefresh = ApiAddress.Host + "/auth/token/apple/access"
    static let Join = ApiAddress.Host + "/auth/apple/login"
    static let CloseAccount = ApiAddress.Host + "/auth/sign"
}
