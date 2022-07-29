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
    
}

extension LoginViewModel : ASAuthorizationControllerDelegate  {
    // 애플 로그인 성공
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            loginResult.onNext(true)
            guard let tokenData = credential.authorizationCode,
                  let token = String(data: tokenData, encoding: .utf8) else {
                Log.e("AuthToken Error")
                return
            }
            Log.d("Token:: \(token)")
//            send(token: token)
        }
    }
    
    // 애플 로그인 실패
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Log.e("\(error)")
        loginResult.onNext(false)
    }
}
