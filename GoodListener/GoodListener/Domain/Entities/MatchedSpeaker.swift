//
//  MatchedSpeaker.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/10/14.
//

import Foundation

struct MatchedSpeaker: Codable {
    var channel: String
    var channelId: Int
    var listenerId: Int
    var speaker: SpeakerInfo
    var nickname: String
    var description: String
    var meetingTime: String
}

struct SpeakerInfo : Codable {
    var id: Int
    var nickName: String
    var gender: String
    var ageRange: String
    var job: String
    var description: String
    var profileImg: Int
}
