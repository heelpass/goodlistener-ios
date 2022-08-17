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
    // 서비스 시작확인 (GET)
    static let ServiceStart = ApiAddress.Host
    // 엑세스 토큰 재발급 (POST)
    static let TokenRefresh = "/auth/token/apple/access"
    // 회원가입 (POST)
    static let Join = "/auth/apple/login"
    // 회원탈퇴 (DELETE)
    static let CloseAccount = "/auth/sign"
}
