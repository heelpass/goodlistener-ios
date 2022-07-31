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

class LoginViewModel: NSObject, ViewModelType {
    
    var disposeBag: DisposeBag = .init()
    var loginResult = PublishSubject<Bool>()    // AppleLogin의 경우 델리게잇을 통해 성공여부를 받기때문에 결과값을 저장할 전역변수를 선언
    
    struct Input {
        var appleLoginBtnTap: Observable<UITapGestureRecognizer>
    }
    
    struct Output {
        var appleLoginResult: Signal<Bool>
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
        
        // Delegate에서 받은 결과를 Output에 바인딩
        loginResult
            .bind(to: appleLoginResult)
            .disposed(by: disposeBag)
        
        return Output(appleLoginResult: appleLoginResult.asSignal(onErrorJustReturn: false))
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
    
    private func practiceMoya(){
        let moyaProvider = MoyaProvider<LoginAPI>()
        
        moyaProvider.rx.request(.signIn)
            .map(WeatherInfo.self)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                switch result {
                case .success(let response):
                    print("지역은 \(response.name ?? "")입니다")
                    print("위도는\(response.coord.lat ?? 0.0)이고, 경도는\(response.coord.lon ?? 0.0)")
                case .failure(let error):
                    print(error.localizedDescription)
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
