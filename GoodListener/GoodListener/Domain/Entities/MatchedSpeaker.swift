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
    
    enum CodingKeys: String, CodingKey {
        case channel
        case channelId
        case listenerId
        case speaker
        case nickname
        case description
        case meetingTime
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.channel = try container.decode(String.self, forKey: .channel)
        self.channelId = try container.decode(Int.self, forKey: .channelId)
        self.listenerId = try container.decode(Int.self, forKey: .listenerId)
        self.speaker = try container.decode(SpeakerInfo.self, forKey: .speaker)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.description = try container.decode(String.self, forKey: .description)
        self.meetingTime = try container.decode(String.self, forKey: .meetingTime)
    }
}

struct SpeakerInfo: Codable {
    var id: Int
    var nickName: String
    var gender: String
    var ageRange: String
    var job: String
    var description: String
    var profileImg: Int
    
    enum CodingKeys: String, CodingKey{
        case id
        case nickName
        case gender
        case ageRange
        case job
        case description
        case profileImg
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        self.nickName = (try? container.decode(String.self, forKey: .nickName)) ?? ""
        self.gender = (try? container.decode(String.self, forKey: .gender)) ?? ""
        self.ageRange = (try? container.decode(String.self, forKey: .ageRange)) ?? ""
        self.job = (try? container.decode(String.self, forKey: .job)) ?? ""
        self.description = (try? container.decode(String.self, forKey: .description)) ?? ""
        self.profileImg = (try? container.decode(Int.self, forKey: .profileImg)) ?? 0
    }
    
}
