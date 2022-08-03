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
import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser


class LoginViewModel: NSObject, ViewModelType {
    
    var disposeBag: DisposeBag = .init()
    var loginResult = PublishSubject<Bool>()    // AppleLogin의 경우 델리게잇을 통해 성공여부를 받기때문에 결과값을 저장할 전역변수를 선언
    var kakaoLoginResult = PublishSubject<Bool>() //kakaoLogin 성공 여부 저장
    
    struct Input {
        var appleLoginBtnTap: Observable<UITapGestureRecognizer>
        var kakaoLoginBtnTap: Observable<UITapGestureRecognizer>
    }
    
    struct Output {
        var appleLoginResult: Signal<Bool>
        var kakaoLoginResult: Signal<Bool>
    }
    
    override init() {
        super.init()
    }
    
    // Input을 Output으로 변환
    func transform(input: Input) -> Output {
        let appleLoginResult = PublishRelay<Bool>()
        
        input.appleLoginBtnTap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.appleLoginHandler()
            })
            .disposed(by: disposeBag)
        
        input.kakaoLoginBtnTap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.kakaoLoginHandler()
            })
            .disposed(by: disposeBag)
        
        // Delegate에서 받은 결과를 Output에 바인딩
        loginResult
            .bind(to: appleLoginResult)
            .disposed(by: disposeBag)
        
        
        return Output(appleLoginResult: appleLoginResult.asSignal(onErrorJustReturn: false), kakaoLoginResult: kakaoLoginResult.asSignal(onErrorJustReturn: false))
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
    
    // Kakao 로그인 핸들러
    private func kakaoLoginHandler() {
        if (UserApi.isKakaoTalkLoginAvailable()) {

            //성공, 실패 여부 판별
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe(onNext:{ (oauthToken) in
                    Log.i("KakaoLogin Succeed")
                    Log.d("Token:: \(oauthToken)")
                    self.kakaoLoginResult.onNext(true)
                    self.practiceMoya()
                }, onError: { [self] error in
                    Log.e("\(error)")
                    self.kakaoLoginResult.onNext(false)
                })
            .disposed(by: disposeBag)
        }
    }
    
    // Token을 서버사이드에 전달
    // Moya로 API부분 설계완료되면 수정 필요
    private func send(token: String) {
        guard let authData = try? JSONEncoder().encode(["token": token]) else {
            return
        }
        guard let url = URL(string: "URL 입력 필요!!") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
            // Handle response from your backend.
        }
        task.resume()
        
    }
    
    // Moya연습용 - 나중에 위와 합치기
    private func practiceMoya(){
        //private func practiveMoya(token: String)
        // ex) 만일 'ABC/DEF'에 token을 post로 보내야 한다고 가정 -> LoginAPI.swift 참고
     
        let moyaProvider = MoyaProvider<LoginAPI>()
        //moyaProvider.rx.request(.signIn(path: DEF, token: token))
        moyaProvider.rx.request(.signIn)
            .map(WeatherInfo.self)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                switch result {
                case .success(let response):
                    print("지역은 \(response.name ?? "")입니다")
                    print("위도는\(response.coord.lat ?? 0.0)이고, 경도는\(response.coord.lon ?? 0.0)")
                case .failure(let error):
                    Log.e("\(error.localizedDescription)")
                }
            }.disposed(by: disposeBag)
    }
}

extension LoginViewModel : ASAuthorizationControllerDelegate  {
    // 애플 로그인 성공
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            loginResult.onNext(true)
            practiceMoya()
            guard let tokenData = credential.authorizationCode,
                  let token = String(data: tokenData, encoding: .utf8) else {
                Log.e("AuthToken Error")
                return
            }
            Log.d("Token:: \(token)")
            send(token: token)
        }
    }
    
    // 애플 로그인 실패
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Log.e("\(error)")
        loginResult.onNext(false)
    }
}
