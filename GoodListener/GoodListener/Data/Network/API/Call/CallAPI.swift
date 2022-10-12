//
//  TokenAPI.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/31.
//

import Moya
import SwiftyJSON

struct CallAPI: Networkable {
    typealias Target = CallTargetType
    
    static func deleteChannel(request: Int, completion: @escaping (_ succeed: Void?, _ failed: Error?)-> Void) {
        makeProvider().request(.deleteChannel(request)) { result in
            switch ResponseData<JSON>.processJSONResponse(result) {
            case .success(let _):
                return completion((), nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
}
