//
//  ProfileSetupViewModel.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/18.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileSetupViewModel: ViewModelType {
    
    var disposeBag: DisposeBag = .init()
    
    struct Input {
        var profileImage: BehaviorRelay<UIImage?>    // 프로필 이미지
        var nickname: Observable<String>             // 입력된 닉네임
        var checkDuplicate: Observable<Void>     // 닉네임 중복 확인
    }
    
    struct Output {
        var nicknameValidationResult: Signal<Bool> // 닉네임 유효성 검사 여부
        var nicknameDuplicateResult: Signal<(String, Bool)> // 닉네임 유효성 검사 여부
        var canComplete: Signal<Bool> // 프로필 설정 완료 가능여부
    }
    
    func transform(input: Input) -> Output {
        let nicknameValidationResult = BehaviorRelay<Bool>(value: false)
        let nicknameDuplicateResult = BehaviorRelay<(String, Bool)>(value: ("", false))
        let canComplete = BehaviorRelay<Bool>(value: false)
        
        // 닉네임이 입력됐을때
        input.nickname
            .subscribe(onNext: { [weak self] (text) in
                guard let self = self else { return }
                // 문자열을 확인 후 output에 넘겨주기
                nicknameValidationResult.accept(self.checkText(text: text))
            })
            .disposed(by: disposeBag)
        
        // 닉네임 중복확인
        input.checkDuplicate
            .withLatestFrom(input.nickname)
            .subscribe(onNext: { [weak self] (text) in
                guard let self = self else { return }
                nicknameDuplicateResult.accept((text, self.checkDuplicateNickname()))
            })
            .disposed(by: disposeBag)
        
        // 프로필 설정 완료 가능 여부 확인
        Observable.combineLatest(input.profileImage, nicknameDuplicateResult)
            .subscribe(onNext: { image, duplicate in
                canComplete.accept(image != nil && nicknameDuplicateResult.value.1)
            })
            .disposed(by: disposeBag)
        
        return Output(nicknameValidationResult: nicknameValidationResult.asSignal(onErrorJustReturn: false),
                      nicknameDuplicateResult: nicknameDuplicateResult.asSignal(onErrorJustReturn: ("", false)),
                      canComplete: canComplete.asSignal(onErrorJustReturn: false)
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
    
    // 닉네임 중복검사 함수 API콜 예정
    func checkDuplicateNickname()-> Bool {
        
        return true
    }
}

