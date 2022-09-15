//
//  HomeViewModel.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/09/10.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType{
    var disposeBag: DisposeBag = .init()
    
    struct Input {
        let naviRightBtnTap: Observable<Void> //알림 버튼
        let joinBtnTap: Observable<Void> // 신청하기 버튼 클릭
        let postponeBtnTap: Observable<Void> //오늘 대화 미루기 버튼 클릭
        let delayBtnTap: Observable<Void> //대화 1회 미루기
    }
    
    struct Output {
        let naviRightBtnResult: Signal<Bool>
        let joinBtnResult: Signal<Bool>
        let postponeBtnResult: Signal<Bool>
        let delayBtnResult: Signal<Bool>
    }
    
    func transform(input: Input) -> Output {
        let naviRightBtnResult = PublishRelay<Bool>()
        let joinBtnResult = PublishRelay<Bool>()
        let postponeBtnResult = PublishRelay<Bool>()
        let delayBtnResult = PublishRelay<Bool>()

        input.naviRightBtnTap
            .subscribe(with: self, onNext: {strong, _ in
                naviRightBtnResult.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.joinBtnTap
            .subscribe(with: self, onNext: {strong, _ in
                joinBtnResult.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.postponeBtnTap
            .subscribe(with: self, onNext: {strong, _ in
                postponeBtnResult.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.delayBtnTap
            .subscribe(with: self, onNext: {strong, _ in
                //TODO: 대화미루기 API 호출
                delayBtnResult.accept(true)
            })
            .disposed(by: disposeBag)
        
        return Output(
            naviRightBtnResult: naviRightBtnResult.asSignal(onErrorJustReturn: false),
            joinBtnResult: joinBtnResult.asSignal(onErrorJustReturn: false),
            postponeBtnResult: postponeBtnResult.asSignal(onErrorJustReturn: false),
            delayBtnResult: delayBtnResult.asSignal(onErrorJustReturn: false)
        )
    }
}
