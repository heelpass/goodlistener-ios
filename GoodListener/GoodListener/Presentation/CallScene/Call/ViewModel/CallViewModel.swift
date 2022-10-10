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
    var callingTimer: Timer?
    var readyTimer: Timer?
    
    var readyTime = 0
    var callingTime = 0
    
    // 리스너가 전화건 횟수
    var callCount = UserDefaultsManager.shared.callCount
    
    struct Input {
        let acceptBtnTap: Observable<Void> // 통화 수락 Socket
        let refuseBtnTap: Observable<Void> // 통화 거절
        let stopBtnTap: Observable<Void> // 통화 종료 Socket
        let delayBtnTap: Observable<Void> // 대화 1회 미루기 Rest
        let state: BehaviorRelay<CallState> // 현재 상태
        let callAgainBtnTap: Observable<Void> // 전화 다시걸기
    }
    
    struct Output {
        let time: Signal<String> // 통화 시간 보내줄예정
        let acceptSocketResult: Signal<Bool> // 수락 후 방입장 성공 여부
        let refuseAPIResult: Signal<Bool> // 통화 거절 API 성공 여부
        let stopSocketResult: Signal<Bool> // 통화 정상 종료 여부
        let delayAPIResult: Signal<Bool> // 대화 미루기 API 성공 여부
        let readyOneMin: Signal<Void> // 전화걸고 1분 기다린경우
        let callEnd: Signal<Void> // 전화 종료
        let callFailThreeTime: Signal<Void> // 전화연결 3회 실패
    }
    
    func transform(input: Input) -> Output {
        let time = BehaviorRelay<String>(value: "0:00 / 3:00")
        let acceptSocketResult = BehaviorRelay<Bool>(value: false)
        let refuseAPIResult = BehaviorRelay<Bool>(value: false)
        let stopSocketResult = BehaviorRelay<Bool>(value: false)
        let delayAPIResult = BehaviorRelay<Bool>(value: false)
        let readyOneMin = PublishRelay<Void>()
        let callEnd = PublishRelay<Void>()
        let callFailThreeTime = PublishRelay<Void>()
        
        func setReadyTimer() {
            self.readyTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
                guard let self = self else { return }
                if self.readyTime == 5 {
                    if self.callCount == 3 {
                        callFailThreeTime.accept(())
                        UserDefaultsManager.shared.callCount = 0
                    } else {
                        readyOneMin.accept(())
                    }
                    self.readyTime = 0
                    self.readyTimer?.invalidate()
                    self.readyTimer = nil
                    return
                }
                self.readyTime += 1
                Log.d("readyTime :: \(self.readyTime)")
            })
        }
        
        func setCallingTimer() {
            self.callingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
                guard let self = self else { return }
                if self.callingTime == 180 {
                    callEnd.accept(())
                    self.callingTimer?.invalidate()
                    self.callingTimer = nil
                    return
                }
                self.callingTime += 1
                
                time.accept(self.converIntToTime(int: self.callingTime))
            })
        }
        
        input.state
            .bind(onNext: { [weak self] state in
                guard let self = self else { return }
                Log.d(state)
                switch state {
                case .ready:
                    if UserDefaultsManager.shared.userType == "listener" {
                        UserDefaultsManager.shared.callCount += 1
                        self.callCount += 1
                        setReadyTimer()
                    }
                case .call:
                    setCallingTimer()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        input.acceptBtnTap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                //TODO: 대화 수락시 소켓 방 입장
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
                      delayAPIResult: delayAPIResult.asSignal(onErrorJustReturn: false),
                      readyOneMin: readyOneMin.asSignal(onErrorJustReturn: ()),
                      callEnd: callEnd.asSignal(onErrorJustReturn: ()),
                      callFailThreeTime: callFailThreeTime.asSignal(onErrorJustReturn: ())
        )
    }
    
    func converIntToTime(int: Int)-> String {
        var sec = "\(int % 60)"
        let min = "\(int / 60)"
        
        if sec.count == 1 {
            sec = "0" + sec
        }
        
        let string = "\(min):\(sec) / 3:00"
        
        return string
    }
    
    deinit {
        readyTimer?.invalidate()
        callingTimer?.invalidate()
        
        readyTimer = nil
        callingTimer = nil
        
        Log.d("CallViewModel Deinit")
    }
}
