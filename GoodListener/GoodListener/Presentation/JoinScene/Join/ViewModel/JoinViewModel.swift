//
//  JoinViewModel.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/09/22.
//

import Foundation
import RxSwift
import RxCocoa

class JoinViewModel: ViewModelType {

    var disposeBag = DisposeBag()
    
    struct Input {
        let time: Observable<[String]> //대화 날짜 + 시간
        let reason: Observable<String> //신청하게 된 계기
        let moodImg: Observable<Int> //이모지(원하는 대화 분위기)
        let okBtnTap: Observable<Void> //확인하기 버튼
    }
    
    struct Output {
        let okBtnResult: Signal<Bool>
        var poupMessage: Signal<String>
        var guestMessage: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        let okBtnResult = PublishRelay<Bool>()
        var popupMessage = PublishRelay<String>()
        var guestMessage = PublishRelay<String>()
        
        input.okBtnTap
            .withLatestFrom(Observable.combineLatest(input.time, input.reason, input.moodImg))
            .subscribe(onNext: { [weak self] (time, reason, moodImg) in
                if UserDefaultsManager.shared.isGuest {
                    guestMessage.accept("로그인 후 이용해주세요")
                    return
                }
                
                if(time == [""] || reason == "" || moodImg == 0) {
                    popupMessage.accept("간략하게 입력해 주시면 \n리스너와 더 좋은 대화를 나눌 수 있어요!")
                } else {
                    MatchAPI.MatchUser(request: MatchModel.init(matchDate: time, applyDesc: reason, wantImg: moodImg), completion: { response, error in
                        guard let model = response else {
                            Log.e(error ?? #function)
                            return
                        }
                    })
                    okBtnResult.accept(true)
                }
            })
            .disposed(by: disposeBag)
        return Output(okBtnResult: okBtnResult.asSignal(onErrorJustReturn: false),
                      poupMessage: popupMessage.asSignal(onErrorJustReturn: ""),
                      guestMessage: guestMessage.asSignal(onErrorJustReturn: ""))
    }
}
