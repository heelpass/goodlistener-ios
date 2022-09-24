//
//  MatchAPI.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/09/25.
//

import Foundation

struct MatchAPI: Networkable {
    typealias Target = MatchTargetType
    
    /// 유저 매칭을 진행합니다.
    /// - Parameter request: (id: Int, matchDate: [String], applyDesc: String, wantImg: Int)
    /// - Returns: Success: MatchModel, Fail: Error
    static func MatchUser(request: (Int, [String], String, Int), completion: @escaping (_ succeed: MatchModel?, _ failed: Error?) -> Void) {
        makeProvider().request(.matchUser(request), completion: { result in
            switch ResponseData<MatchModel>.processModelResponse(result) {
            case .success(let model):
                return completion(model, nil)
            case .failure(let error):
                makePopup(action: {
                   MatchUser(request: request, completion: completion)
                })
                return completion(nil, error)
            }
        })
    }
}
