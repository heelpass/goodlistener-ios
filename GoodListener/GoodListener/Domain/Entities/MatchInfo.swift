//
//  MatchInfo.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/09/29.
//

import Foundation
	
struct MatchInfo: Codable {
    var matchDate: [String]
    var applyDesc: String
    var wantImg: Int

    enum Codingkeys: Any, CodingKey {
        case matchDate
        case applyDesc
        case wantImg
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Codingkeys.self)
        self.matchDate = (try? values.decode([String].self, forKey: .matchDate)) ?? [""]
        self.applyDesc = (try? values.decode(String.self, forKey: .applyDesc)) ?? ""
        self.wantImg = (try? values.decode(Int.self, forKey: .wantImg)) ?? 0

    }
}
