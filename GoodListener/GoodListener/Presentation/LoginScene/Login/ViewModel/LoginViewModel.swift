//
//  LoginViewModel.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/29.
//

import Foundation
import RxSwift
import RxCocoa
import RxGesture
import AuthenticationServices
import Moya
import SwiftyJSON


class LoginViewModel: NSObject, ViewModelType {
    
    var disposeBag: DisposeBag = .init()
    var loginResult = PublishSubject<Bool>()    // AppleLogin, kakaoLogin의 결과값을 저장하기 위해 전역 변수를 선언함
    
    struct Input {
        var appleLoginBtnTap: Observable<UITapGestureRecognizer>
        var nonLoginBtnTap: Observable<UITapGestureRecognizer>
        var termsOfServiceBtnTap: Observable<UITapGestureRecognizer>
    }
    
    struct Output {
        var loginResult: Signal<Bool>
    }
    
    override init() {
        super.init()
    }
    
    // Input을 Output으로 변환
    func transform(input: Input) -> Output {
        let loginResult = PublishRelay<Bool>()
        
        input.appleLoginBtnTap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.appleLoginHandler()
            })
            .disposed(by: disposeBag)
        
        input.nonLoginBtnTap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                loginResult.accept(true)
                UserDefaultsManager.shared.isGuest = true
                UserDefaultsManager.shared.nickname    = "Guest"
                UserDefaultsManager.shared.age         = ""
                UserDefaultsManager.shared.gender      = ""
                UserDefaultsManager.shared.job         = ""
                UserDefaultsManager.shared.profileImg  = 1
                UserDefaultsManager.shared.description = "안녕하세요 굿 리스너입니다."
                UserDefaultsManager.shared.userType    = "speaker"
            })
            .disposed(by: disposeBag)
        
        // Delegate에서 받은 결과를 Output에 바인딩
        self.loginResult
            .bind(to: loginResult)
            .disposed(by: disposeBag)
        
        
        return Output(loginResult: loginResult.asSignal(onErrorJustReturn: false))
    }
    
    // Apple 로그인 핸들러
    private func appleLoginHandler() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
    
    // Token을 서버사이드에 전달
    // Moya로 API부분 설계완료되면 수정 필요
    // MARK: 네트워크 구조화 after
    private func send(token: String) {
        TokenAPI.requestAppleToken(request: token, completion: { response, error in
            guard let response = response else {
                Log.e(error ?? #function)
                return
            }
            
            UserDefaultsManager.shared.accessToken = response.token
            
            if response.isExistUser {
                // 유저가 이미 가입한 경우
                // 유저 정보를 불러오는 API request
                UserAPI.requestUserInfo { response, error in
                    guard let model = response else {
                        Log.e(error ?? #function)
                        return
                    }
                    UserInfoManager.shared.userInfo = model
                    
                    UserDefaultsManager.shared.nickname    = model.nickname
                    UserDefaultsManager.shared.age         = model.ageRange
                    UserDefaultsManager.shared.gender      = model.gender
                    UserDefaultsManager.shared.job         = model.job
                    UserDefaultsManager.shared.profileImg  = model.profileImg
                    UserDefaultsManager.shared.description = model.description
                    UserDefaultsManager.shared.userType    = model.kind.type
                    
                    self.loginResult.onNext(true)
                    UserDefaultsManager.shared.isLogin = true
                    
                    UserAPI.updateDeviceToken(request: UserDefaultsManager.shared.fcmToken, completion: { (result, error) in
                        guard let model = result else {
                            Log.e(error ?? #function)
                            return
                        }
                    })
                }
            } else {
                // 유저가 가입하지 않은 경우
                self.loginResult.onNext(false)
                UserDefaultsManager.shared.isLogin = false
            }
        })
        // MARK: 네트워크 구조화 before
//        let moyaProvider = MoyaProvider<TokenTargetType>()
//        moyaProvider.rx.request(.getAppleToken(token))
//            .observe(on: MainScheduler.instance)
//            .subscribe { [weak self] result in
//                guard let self = self else { return }
//                switch result {
//                case .success(let response):
//                    let jsonData = JSON(response.data)
//                    Log.d(jsonData)
//                    if let token = jsonData["token"].string {
//                        UserDefaultsManager.shared.accessToken = token
//                    }
//
//                    // 이미 회원으로 등록된 경우 회원정보를 불러온다.
//                    if jsonData["isExistUser"].boolValue {
//                        self.getUserInfo { _ in
//                            self.loginResult.onNext(true)
//                            UserDefaultsManager.shared.isLogin = true
//                            // TODO: 회원정보를 불러오기 실패한 경우에는 어떻게 할껀지?
//                        }
//                    } else {
//                        self.loginResult.onNext(false)
//                        UserDefaultsManager.shared.isLogin = false
//                    }
//
//                case .failure(let error):
//                    Log.e("\(error.localizedDescription)")
//                }
//            }.disposed(by: disposeBag)
        
    }
}

extension LoginViewModel : ASAuthorizationControllerDelegate  {
    // 애플 로그인 성공
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let tokenData = credential.authorizationCode,
                  let token = String(data: tokenData, encoding: .utf8),
                  let identityToken = credential.identityToken,
                  let identity = String(data: identityToken, encoding: .utf8)
            else {
                Log.e("AuthToken Error")
                return
            }
            Log.d("AppleID:: \(credential.user)")
            UserDefaultsManager.shared.appleID = credential.user
            Log.d("Token:: \(token)")
            Log.d("Identity:: \(identity)")
            UserDefaultsManager.shared.accessToken = identity
            UserDefaultsManager.shared.snsKind = "apple"
            send(token: token)
        }
    }
    
    // 애플 로그인 실패
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Log.e("\(error)")
    }
}
