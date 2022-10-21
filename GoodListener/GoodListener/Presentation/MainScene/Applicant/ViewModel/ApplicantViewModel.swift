//
//  ApplicantViewModel.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/10/21.
//

import Foundation
import RxSwift
import RxCocoa

class ApplicantViewModel: ViewModelType{
    var disposeBag: DisposeBag = .init()
    
    struct Input {
        let naviRightBtnTap: Observable<Void> //네비게이션 버튼
        let callBtnTap: Observable<Void> //전화하기 버튼
    }
    
    struct Output {
        let naviRightBtnResult: Signal<Bool>
        let callBtnResult: Signal<Bool>
    }
    
    func transform(input: Input) -> Output {
        let naviRightBtnResult = PublishRelay<Bool>()
        let callBtnResult = PublishRelay<Bool>()
     
        input.naviRightBtnTap
            .subscribe(with: self, onNext: {weakself, _ in
                naviRightBtnResult.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.callBtnTap
            .subscribe(with: self, onNext: {weakself, _ in
                callBtnResult.accept(true)
            })
            .disposed(by: disposeBag)
        
        return Output(naviRightBtnResult: naviRightBtnResult.asSignal(onErrorJustReturn: true),
                      callBtnResult: callBtnResult.asSignal(onErrorJustReturn: true)
        )
    }
}
