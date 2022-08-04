//
//  LoginAPI.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/07/31.


import Foundation
import Moya

//🔎 참고: https://github.com/Moya/Moya/blob/master/docs/Targets.md
//

//ex) 만일 'ABC/DEF'에 token을 post로 보내야 한다고 가정
// case signIn(path: String, token: String)
public enum LoginAPI {
    case signIn
    case signOut
    case leave
}


// TargetType Protocol Implementation
extension LoginAPI: TargetType {
    
    //서버의 base URL / Moya는 이를 통하여 endpoint객체 생성
    // return URL(string: "ABC")
    public var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=seoul&appid=e64744f55787649f18b384852530434e")!
    }
    
    // 서버의 base URL 뒤에 추가 될 Path (일반적으로 API)
    // case .signIn(path, _) return "/\(path)"
    public var path: String {
        switch self {
        case .signIn:
            return ""
        case .signOut:
            return ""
        case .leave:
            return ""
        }
    }
    
    // HTTP 메소드 (ex. .get / .post / .delete 등등)
    // case .signIn: return .post
    public var method: Moya.Method {
        switch self {
        case .signIn:
            return .get
        case .signOut:
            return .post
        case .leave:
            return .post
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
        case .signIn:
            return .requestPlain
        case .signOut:
            return .requestPlain
        case .leave:
            return .requestPlain
        }
    }
    
    // HTTP header
    //  return ["Content-type": "application/json"]
    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
    // 테스트용 Mock Data
    public var sampleData: Data {
        return Data()
    }
}
