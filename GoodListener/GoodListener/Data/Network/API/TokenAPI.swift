//
//  TokenAPI.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/31.
//

import Moya

struct TokenAPI: Networkable {
    typealias Target = TokenTargetType
    /// (request: 요청시 보낼 데이터, completion: success시 디코딩할 데이터 모델)
    static func getAppleToken(request: String, completion: @escaping (_ succeed: AppleToken?, _ failed: Error?) -> Void) {
        makeProvider().request(.getAppleToken(request)) { result in
            // ResponseData<❗️success시 디코딩할 데이터 모델: Codable형식 이여야 함❗️>
            switch ResponseData<AppleToken>.processJSONResponse(result) {
            case .success(let model):
                return completion(model, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
}
