//
//  MatchedListener.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/10/05.
//

import Foundation

struct MatchedListener: Codable {
    var nickname: String
    var description: String
    var speakerId: Int
    var listenerId: Int
    var channel: String
    var meetingTime: String
}
