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
        let okBtnTap: Observable<Void> //확인하기 버튼
    }
    
    struct Output {
        let okBtnResult: Signal<Bool>
    }
    
    func transform(input: Input) -> Output {
        let okBtnResult = PublishRelay<Bool>()
        
        input.okBtnTap
            .subscribe(with: self, onNext: {strong, _ in
                okBtnResult.accept(true)
            })
            .disposed(by: disposeBag)
        
        return Output(okBtnResult: okBtnResult.asSignal(onErrorJustReturn: false))
    }
}
