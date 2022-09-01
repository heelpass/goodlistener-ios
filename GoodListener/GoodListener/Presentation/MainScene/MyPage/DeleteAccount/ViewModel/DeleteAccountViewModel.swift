//
//  DeleteAccountViewModel.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/30.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class DeleteAccountViewModel: ViewModelType {

    var disposeBag: DisposeBag = .init()
    
    struct Input {
        var checkboxSeledted: Observable<Bool>  // 체크박스 선택 여부
        var yesBtnTap: Observable<Void>         // 탈퇴버튼 터치
        var deleteAccount: Observable<Void>     // 틸퇴버튼 터치 후 팝업에서 확인 눌렀을때
    }
    
    struct Output {
        var popupMessage: Signal<String>        // 팝업메시지
        var deleteAccountResult: Signal<Bool>   // 회원탈퇴처리 결과
    }
    
    func transform(input: Input) -> Output {
        let popupMessage = PublishRelay<String>()
        let deleteAccountResult = PublishRelay<Bool>()
        
        input.yesBtnTap
            .withLatestFrom(input.checkboxSeledted)
            .subscribe(onNext: {
                if $0 {
                    // 체크박스가 선택된 경우 탈퇴 팝업
                    popupMessage.accept(PopupMessage.deleteAccount)
                } else {
                    // 체크박스가 선택되지 않은 경우에는 내용 확인 팝업
                    popupMessage.accept(PopupMessage.deleteAccountDescriptionCheck)
                }
            })
            .disposed(by: disposeBag)
        
        input.deleteAccount
            .subscribe(onNext: {
                UserAPI.reqeustDeleteAccount(completion: { response, error in
                    guard let _ = response else {
                        Log.e(error ?? #function)
                        return
                    }
                    deleteAccountResult.accept(true)
                })
            })
            .disposed(by: disposeBag)
        
        return Output(popupMessage: popupMessage.asSignal(onErrorJustReturn: ""),
                      deleteAccountResult: deleteAccountResult.asSignal(onErrorJustReturn: false))
    }
    
}
