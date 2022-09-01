//
//  ProfileSetupViewModel.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/18.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class ProfileSetupViewModel: ViewModelType {
    
    var disposeBag: DisposeBag = .init()
    
    struct Input {
        var profileImage: BehaviorRelay<Int?>    // 프로필 이미지
        var nickname: Observable<String>             // 입력된 닉네임
        var checkDuplicate: Observable<Void>     // 닉네임 중복 확인
        var signIn: Observable<SignInModel>     // 
    }
    
    struct Output {
        var nicknameValidationResult: Signal<Bool> // 닉네임 유효성 검사 여부
        var nicknameDuplicateResult: Signal<(String, Bool)> // 닉네임 유효성 검사 여부
        var canComplete: Signal<Bool> // 프로필 설정 완료 가능여부
        var signInSuccess: Signal<Bool> // 회원가입 성공 여부
    }
    
    func transform(input: Input) -> Output {
        let nicknameValidationResult = BehaviorRelay<Bool>(value: true)
        let nicknameDuplicateResult = BehaviorRelay<(String, Bool)>(value: ("", true))
        let canComplete = BehaviorRelay<Bool>(value: false)
        let signInSuccess = BehaviorRelay<Bool>(value: false)
        
        // 닉네임이 입력됐을때
        input.nickname
            .subscribe(onNext: { [weak self] (text) in
                guard let self = self else { return }
                // 문자열을 확인 후 output에 넘겨주기
                nicknameValidationResult.accept(self.checkText(text: text))
                // 중복확인 후 문자열이 바뀐경우
                // 중복확인된 시점과 문자열이 같아진 경우 완료버튼 활성화 ( 닉네임을 썼다 지운 경우 )
                // 중복확인된 시점과 문자열이 다른경우 비활성화
                if !nicknameDuplicateResult.value.0.isEmpty {
                    nicknameDuplicateResult.value.0 == text ? canComplete.accept(true) : canComplete.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        // 닉네임 중복확인
        input.checkDuplicate
            .withLatestFrom(input.nickname)
            .subscribe(onNext: { [weak self] (text) in
                guard let self = self else { return }
                
                UserAPI.requestNicknameCheck(request: text, completion: { response, error in
                    guard let response = response else {
                        Log.e(error ?? #function)
                        return
                    }
                    nicknameDuplicateResult.accept((text,response))

                })
            })
            .disposed(by: disposeBag)
        
        // 프로필 설정 완료 가능 여부 확인
        Observable.combineLatest(input.profileImage, nicknameDuplicateResult)
            .subscribe(onNext: { image, duplicate in
                canComplete.accept(image != nil && !nicknameDuplicateResult.value.1)
            })
            .disposed(by: disposeBag)
        
        input.signIn
            .subscribe(onNext: { model in
                var data = model
                data.snsKind = UserDefaultsManager.shared.snsKind
                data.fcmHash = UserDefaultsManager.shared.fcmToken
                
                UserAPI.requestSignIn(request: data, completion: { response, error in
                    guard let model = response else {
                        Log.e(error ?? #function)
                        return
                    }
                    UserDefaultsManager.shared.nickname    = model.nickname
                    UserDefaultsManager.shared.age         = model.ageRange
                    UserDefaultsManager.shared.gender      = model.gender
                    UserDefaultsManager.shared.job         = model.job
                    UserDefaultsManager.shared.profileImg  = model.profileImg
                    UserDefaultsManager.shared.description = model.description
                    signInSuccess.accept(true)
                })
            })
            .disposed(by: disposeBag)
        
        return Output(nicknameValidationResult: nicknameValidationResult.skip(2).asSignal(onErrorJustReturn: false),
                      nicknameDuplicateResult: nicknameDuplicateResult.asSignal(onErrorJustReturn: ("", false)),
                      canComplete: canComplete.asSignal(onErrorJustReturn: false),
                      signInSuccess: signInSuccess.asSignal(onErrorJustReturn: false)
        )
    }
    
    // 정규식을 통해 문자열을 걸러내는 함수
    func checkText(text: String)-> Bool {
        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣A-Za-z0-9]{1,10}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.count)) {
            return true
        } else {
            return false
        }
    }
}

