//
//  SetUserInModel.swift
//  GoodListener
//
//  Created by cheonsong on 2022/09/30.
//

import Foundation
import SocketIO

struct SetUserInModel: Codable, SocketData {
    var listenerId  : Int
    var channel     : String
    var meetingTime : String
    var speakerId   : Int
    var isListener  : Bool
    var channelId   : Int
    
    func socketRepresentation() throws -> SocketData {
        return [
            "listenerId" : listenerId,
            "channel" : channel,
            "meetingTime" : meetingTime,
            "speakerId" : speakerId,
            "isListener" : isListener,
            "channelId" : channelId
        ]
    }
    
    var json: String {
        return ""
    }
    
    init(listenerId: Int, channel: String, meetingTime: String, speakerId: Int, isListener: Bool, channelId: Int) {
        self.listenerId = listenerId
        self.channel = channel
        self.meetingTime = meetingTime
        self.speakerId = speakerId
        self.isListener = isListener
        self.channelId = channelId
    }
}
