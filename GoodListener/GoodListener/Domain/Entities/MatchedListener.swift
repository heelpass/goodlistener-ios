//
//  MatchedListener.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/10/05.
//

import Foundation

struct MatchedListener: Codable {
    var meetingTime: String
    var nickname: String
    var speakerId: Int
    var channel: String
    var listener : ListenerInfo
    var description: String
    var channelId: Int
}

struct ListenerInfo: Codable {
    var profileImg: Int
    var gender: String
    var nickName: String
    var ageRange: String
    var description: String
    var id : Int
    var job: String
}
