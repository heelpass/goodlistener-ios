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
        //let id: Observable<Int>
        let time: Observable<[String]> //대화 날짜 + 시간
        let reason: Observable<String> //신청하게 된 계기
        let wantImg: Observable<Int> //이모지(원하는 대화 분위기)
        let okBtnTap: Observable<Void> //확인하기 버튼
    }
    
    struct Output {
        let okBtnResult: Signal<Bool>
    }
    
    func transform(input: Input) -> Output {
        let okBtnResult = PublishRelay<Bool>()
        
        //확인 버튼 클릭 시 tuple로 API 호출하기
//        input.okBtnTap
//            .withLatestFrom(Observable.combineLatest(input.emojiwant, input.reason, input.time))
//

        return Output(okBtnResult: okBtnResult.asSignal(onErrorJustReturn: false))
    }
}
