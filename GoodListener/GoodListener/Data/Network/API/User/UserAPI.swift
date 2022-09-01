//
//  UserAPI.swift
//  GoodListener
//
//  Created by cheonsong on 2022/09/01.
//

import Foundation
import SwiftyJSON

struct UserAPI: Networkable {
    typealias Target = UserTargetType
    
    /// 사용자 정보를 요청합니다.
    /// - Returns: Success: UserInfo, Fail: Error
    static func requestUserInfo(completion: @escaping (_ succeed: UserInfo?, _ failed: Error?) -> Void) {
        makeProvider().request(.getUserInfo, completion: { result in
            switch ResponseData<UserInfo>.processJSONResponse(result) {
            case .success(let model):
                return completion(model, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        })
    }
    
    /// 회원가입을 요청합니다.
    /// - Parameter request: SignInModel
    /// - Returns: Success: UserInfo, Fail: Error
    static func requestSignIn(request: SignInModel, completion: @escaping (_ succeed: UserInfo?, _ failed: Error?) -> Void) {
        makeProvider().request(.signIn(request), completion: { result in
            switch ResponseData<UserInfo>.processJSONResponse(result) {
            case .success(let model):
                return completion(model, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        })
    }
    
    /// 회원탈퇴를 요청합니다.
    /// - Returns: Success: Void, Fail: Error
    static func reqeustDeleteAccount(completion: @escaping (_ succeed: Void?, _ failed: Error?) -> Void) {
        makeProvider().request(.deleteAccount, completion: { result in
            switch result {
            case .success(_):
                return completion((), nil)
            case .failure(let error):
                return completion(nil, error)
            }
        })
    }
    
    /// 닉네임 중복 여부를 요청합니다.
    /// - Parameter request: nickname: String
    /// - Returns: Success: Bool, Fail: Error
    static func requestNicknameCheck(request: String, completion: @escaping (_ succeed: Bool?, _ failed: Error?) -> Void) {
        makeProvider().request(.nicknameCheck(request), completion: { result in
            switch ResponseData<JSON>.processSwiftyJSONResponse(result) {
            case .success(let model):
                return completion(model["isExist"].bool, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        })
    }
    
    /// 닉네임 중복 여부를 요청합니다.
    /// - Parameter request: (nickname: String, job: String, description: String)
    /// - Returns: Success: UserInfo, Fail: Error
    static func updateUserInfo(request: (String, String, String), completion: @escaping (_ succeed: UserInfo?, _ failed: Error?) -> Void) {
        makeProvider().request(.userModify(request), completion: { result in
            switch ResponseData<UserInfo>.processJSONResponse(result) {
            case .success(let model):
                return completion(model, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        })
    }

}
