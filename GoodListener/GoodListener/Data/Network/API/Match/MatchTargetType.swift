//
//  MatchTargetType.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/09/25.
//

import Foundation
import Moya

//🔎 참고: https://github.com/Moya/Moya/blob/master/docs/Targets.md

//ex) 만일 'ABC/DEF'에 token을 post로 보내야 한다고 가정
// case signIn(path: String, token: String)
enum MatchTargetType {
    case matchUser(MatchModel)
    case myListener
    case mySpeaker
}


// TargetType Protocol Implementation
extension MatchTargetType: BaseTargetType {
    
    // 서버의 base URL 뒤에 추가 될 Path (일반적으로 API)
    // case .signIn(path, _) return "/\(path)"
    public var path: String {
        switch self {
        case .matchUser(_):
            return "/match/user"
        case .myListener:
            return "/match/user/listener"
        case .mySpeaker:
            return "/match/user/speaker"
        }
    }
    
    // HTTP 메소드 (ex. .get / .post / .delete 등등)
    // case .signIn: return .post
    public var method: Moya.Method {
        switch self {
        case .matchUser(_):
            return .post
        case .myListener, .mySpeaker:
            return .get
        }

    }
    
    // task : request에 사용되는 파라미터 설정
    // - plain request : 추가 데이터가 없는 request
    // - data request : 데이터가 포함된 requests body
    // - parameter request : 인코딩된 매개 변수가 있는 requests body
    // - JSONEncodable request : 인코딩 가능한 유형의 requests body
    // - upload request
    
    // case let .signIn(_, token): return .requestJSONEncodable(["accesstoken": token])
    public var task: Task {
        switch self {
        case .matchUser(let model):
            return .requestJSONEncodable(model)
        case .myListener, .mySpeaker:
            return .requestPlain
        }
    }
}
