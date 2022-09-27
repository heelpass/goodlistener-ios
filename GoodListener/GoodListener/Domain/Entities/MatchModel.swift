//
//  MatchModel.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/09/24.
//

import Foundation

struct MatchModel: Codable {
    var matchDate: [String]
    var applyDesc: String
    var wantImg: Int

    enum Codingkeys: String, CodingKey {
        case matchDate
        case applyDesc
        case wantImg
    }
}
