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
    /// - Body:  MatchModel(id: Int, matchDate: [String], applyDesc: String, wantImg: Int)
    /// - Returns: Success: MatchModel, Fail: Error
    static func MatchUser(request: MatchModel, completion: @escaping (_ succeed: MatchInfo?, _ failed: Error?) -> Void) {
        makeProvider().request(.matchUser(request), completion: { result in
            switch ResponseData<MatchInfo>.processModelResponse(result) {
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
    
    //매칭 유저 정보를 불러옵니다.
    /// - Returns:Success: MatchedListener, Fail: Error
    static func MatchedListener(completion: @escaping (_ succeed: MatchedListener?, _ failed: Error?) -> Void) {
        makeProvider().request(.myListener, completion: { result in
            switch ResponseData<MatchedListener>.processModelResponse(result) {
            case .success(let model):
                return completion(model, nil)
            case .failure(let error):
                makePopup(action: {
                   MatchedListener(completion: completion)
                })
                return completion(nil, error)
            }
            
        })
    }
}
