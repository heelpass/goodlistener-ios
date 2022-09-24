//
//  MatchModel.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/09/24.
//

import Foundation

struct MatchModel: Codable {
    var id: Int //TODO: -token으로 바뀐다고 함
    var matchDate: [String]
    var applyDesc: String
    var wantImg: Int

    enum Codingkeys: String, CodingKey {
        case id
        case matchDate
        case applyDesc
        case wantImg
    }
}
