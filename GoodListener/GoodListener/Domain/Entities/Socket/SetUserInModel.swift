//
//  SetUserInModel.swift
//  GoodListener
//
//  Created by cheonsong on 2022/09/30.
//

import Foundation

struct SetUserInModel: Encodable {
    var listenerId: Int
    var channel: String
    var meetingTime: String
    var speakerId: Int
    var isListener: Bool
    
    init(listenerId: Int, channel: String, meetingTime: String, speakerId: Int, isListener: Bool) {
        self.listenerId = listenerId
        self.channel = channel
        self.meetingTime = meetingTime
        self.speakerId = speakerId
        self.isListener = isListener
    }
}
