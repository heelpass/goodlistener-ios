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
    }
    
    func transform(input: Input) -> Output {
        let okBtnResult = PublishRelay<Bool>()
        
        //TODO: validationCheck필요함
        
        
        
        input.okBtnTap
            .withLatestFrom(Observable.combineLatest(input.time, input.reason, input.moodImg))
            .subscribe(onNext: { [weak self] (time, reason, moodImg) in
                Log.d((time, reason, moodImg))
                MatchAPI.MatchUser(request: (time, reason, moodImg), completion: { response, error in
                    guard let model = response else {
                        Log.e(error ?? #function)
                        return
                    }
                })
            })
        return Output(okBtnResult: okBtnResult.asSignal(onErrorJustReturn: false))
    }
}
