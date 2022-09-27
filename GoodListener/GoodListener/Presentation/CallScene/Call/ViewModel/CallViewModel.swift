//
//  CallViewModel.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/23.
//

import Foundation
import RxSwift
import RxCocoa

class CallViewModel: ViewModelType {
    var disposeBag: DisposeBag = .init()
    var timer: Timer?
    
    struct Input {
        let acceptBtnTap: Observable<Void> // 통화 수락 Socket
        let refuseBtnTap: Observable<Void> // 통화 거절
        let stopBtnTap: Observable<Void> // 통화 종료 Socket
        let delayBtnTap: Observable<Void> // 대화 1회 미루기 Rest
    }
    
    struct Output {
        let time: Signal<String> // 통화 시간 보내줄예정
        let acceptSocketResult: Signal<Bool> // 수락 후 방입장 성공 여부
        let refuseAPIResult: Signal<Bool> // 통화 거절 API 성공 여부
        let stopSocketResult: Signal<Bool> // 통화 정상 종료 여부
        let delayAPIResult: Signal<Bool> // 대화 미루기 API 성공 여부
    }
    
    func transform(input: Input) -> Output {
        let time = BehaviorRelay<String>(value: "0:00 / 3:00")
        let acceptSocketResult = BehaviorRelay<Bool>(value: false)
        let refuseAPIResult = BehaviorRelay<Bool>(value: false)
        let stopSocketResult = BehaviorRelay<Bool>(value: false)
        let delayAPIResult = BehaviorRelay<Bool>(value: false)
        
        input.acceptBtnTap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                // 스피커일 경우 전화
            })
            .disposed(by: disposeBag)
        
        input.refuseBtnTap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                //TODO: 대화 거절 시 REST
                // 대화 수락전에는 소켓방에 입장하지 않음 그러면 REST로 보내는게 맞을듯
            })
            .disposed(by: disposeBag)
        
        input.stopBtnTap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                //TODO: 대화 종료 시 소켓으로 emit
                // emit에 실패하지 않으면 후기 남기기로 가야할듯
            })
            .disposed(by: disposeBag)
        
        input.delayBtnTap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                //TODO: 대화 미루기 REST
                
            })
            .disposed(by: disposeBag)
        
        return Output(time: time.asSignal(onErrorJustReturn: "문제가 발생하였습니다."),
                      acceptSocketResult: acceptSocketResult.asSignal(onErrorJustReturn: false),
                      refuseAPIResult: refuseAPIResult.asSignal(onErrorJustReturn: false),
                      stopSocketResult: stopSocketResult.asSignal(onErrorJustReturn: false),
                      delayAPIResult: delayAPIResult.asSignal(onErrorJustReturn: false)
        )
    }
}
