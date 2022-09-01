//
//  MyPageModifyViewModel.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/30.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class MyPageModifyViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        var nickname: Observable<String>
        var job: Observable<String>
        var introduce: Observable<String>
        var checkDuplicate: Observable<Void>
        var saveBtnTap: Observable<Void>
    }
    
    struct Output {
        var nicknameValidationResult: Signal<Bool> // 닉네임 유효성 검사 여부
        var nicknameDuplicateResult: Signal<(String, Bool)> // 닉네임 유효성 검사 여부
        var popupMessage: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        let nicknameValidationResult = BehaviorRelay<Bool>(value: true)
        let nicknameDuplicateResult = BehaviorRelay<(String, Bool)>(value: ("", true))
        let popupMessage = PublishRelay<String>()
        
        // 닉네임이 입력됐을때
        input.nickname
            .subscribe(onNext: { [weak self] (text) in
                guard let self = self else { return }
                // 문자열을 확인 후 output에 넘겨주기
                nicknameValidationResult.accept(self.checkText(text: text))
                // 중복확인 후 문자열이 바뀐경우
                // 중복확인된 시점과 문자열이 같아진 경우 완료버튼 활성화 ( 닉네임을 썼다 지운 경우 )
                // 중복확인된 시점과 문자열이 다른경우 비활성화
            })
            .disposed(by: disposeBag)
        
        // 닉네임 중복확인
        input.checkDuplicate
            .withLatestFrom(input.nickname)
            .subscribe(onNext: { (text) in
                UserAPI.requestNicknameCheck(request: text, completion: { response, error in
                    guard let response = response else {
                        Log.e(error ?? "checkDuplicate")
                        return
                    }
                    nicknameDuplicateResult.accept((text,response))

                })
            })
            .disposed(by: disposeBag)
        
        input.saveBtnTap
            .withLatestFrom(Observable.combineLatest(input.nickname, input.job, input.introduce))
            .subscribe(onNext: { [weak self] (nickname, job, introduce) in
                // 닉네임 변경 여부 확인
                if nickname != UserDefaultsManager.shared.nickname {
                    if nicknameDuplicateResult.value.1 {
                        // 중복체크 안됨 팝업 띄워줄 예정
                        popupMessage.accept("닉네임 중복확인을 해주세요")
                    } else {
                        UserAPI.updateUserInfo(request: (nickname, job, introduce), completion: { response, error in
                            guard let model = response else {
                                Log.e(error ?? #function)
                                return
                            }
                            UserDefaultsManager.shared.nickname = model.nickname
                            UserDefaultsManager.shared.job = model.job
                            UserDefaultsManager.shared.description = model.description
                            popupMessage.accept("회원 정보가 수정되었습니다")
                        })
                    }

                } else if job != UserDefaultsManager.shared.job || introduce != UserDefaultsManager.shared.description {
                    UserAPI.updateUserInfo(request: (nickname, job, introduce), completion: { response, error in
                        guard let model = response else {
                            Log.e(error ?? #function)
                            return
                        }
                        UserDefaultsManager.shared.nickname = model.nickname
                        UserDefaultsManager.shared.job = model.job
                        UserDefaultsManager.shared.description = model.description
                        popupMessage.accept("회원 정보가 수정되었습니다")
                    })
                } else {
                    popupMessage.accept("수정된 회원 정보가 없습니다")
                }
                
            })
            .disposed(by: disposeBag)
        
        return Output(nicknameValidationResult: nicknameValidationResult.asSignal(onErrorJustReturn: false),
                      nicknameDuplicateResult: nicknameDuplicateResult.asSignal(onErrorJustReturn: ("", true)),
                      popupMessage: popupMessage.asSignal(onErrorJustReturn: ""))
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
