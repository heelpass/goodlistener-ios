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
    
    var model: [MatchedSpeaker]?
    
    // 리스너가 전화건 횟수
    var callCount = UserDefaultsManager.shared.callCount
    
    var token = BehaviorRelay<String?>(value: nil)
    var isAccepted = BehaviorRelay<Bool>(value: false)
    
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
        let outputState: PublishRelay<CallState> // 현재 상태
    }
    
    init(model: [MatchedSpeaker]?) {
        self.model = model
        socketBind()
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
        let outputState = PublishRelay<CallState>()
        
        func setReadyTimer() {
            self.readyTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
                guard let self = self else { return }
                if self.readyTime == 60 {
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
                    CallManager.shared.stop()
                    GLSocketManager.shared.disconnected()
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
                    break
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        CallManager.shared.enterSpeakerAndListener
            .subscribe(onNext: {
                setCallingTimer()
            })
            .disposed(by: disposeBag)
        
        input.acceptBtnTap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                // 스피커일 경우 전화
                self.isAccepted.accept(true)
                if self.token.value != nil {
                    CallManager.shared.start(token: self.token.value!, channelId: UserDefaultsManager.shared.channel, uid: UserDefaultsManager.shared.speakerId) { _, _, _ in
                        self.readyTimer?.invalidate()
                        self.readyTimer = nil
                        outputState.accept(.call)
                    }
                }
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
                CallManager.shared.stop()
                GLSocketManager.shared.disconnected()
                // TODO: 채널ID로 채널 삭제
                CallAPI.deleteChannel(request: self.model?.first?.channelId ?? 0, completion: { succeed,failed in
                    Log.d("채널 Delete 성공")
                })
            })
            .disposed(by: disposeBag)
        
        input.delayBtnTap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                //TODO: 대화 미루기 REST
                
            })
            .disposed(by: disposeBag)
        
        // 리스너가 아고라토큰을 요청 후 토큰을 받았을 때
        GLSocketManager.shared.relays.createAgoraToken
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                guard let token = data.first as? String else { return }
                CallManager.shared.start(token: token, channelId: self.model?.first?.channel ?? "", uid: self.model?.first?.listenerId ?? 0) {
                    Log.d($0)
                    Log.d($1)
                    Log.d($2)
                    self.readyTimer?.invalidate()
                    self.readyTimer = nil
                    outputState.accept(.call)
                }
                
            })
            .disposed(by: disposeBag)
        
        // SpeakerIn FCM 도착 시 - 리스너만 실행됨
        AppState.speakerIn.subscribe(onNext: {
            GLSocketManager.shared.createAgoraToken()
//            CallManager.shared.start(token: "", channelId: "3418bef7-1343-4c05-a1fe-4dca0bab6c68", uid: 0)
        })
        .disposed(by: disposeBag)
        
        // AgoraToken FCM 도착 시 - 스피커만 실행됨
        AppState.agoraToken.subscribe(onNext: { [weak self] token in
            guard let self = self else { return }
            self.token.accept(token)
            
            if self.isAccepted.value {
                CallManager.shared.start(token: token, channelId: UserDefaultsManager.shared.channel , uid: UserDefaultsManager.shared.speakerId) { _, _, _ in
                    self.readyTimer?.invalidate()
                    self.readyTimer = nil
                    outputState.accept(.call)
                }
            }
        })
        .disposed(by: disposeBag)
        
        return Output(time: time.asSignal(onErrorJustReturn: "문제가 발생하였습니다."),
                      acceptSocketResult: acceptSocketResult.asSignal(onErrorJustReturn: false),
                      refuseAPIResult: refuseAPIResult.asSignal(onErrorJustReturn: false),
                      stopSocketResult: stopSocketResult.asSignal(onErrorJustReturn: false),
                      delayAPIResult: delayAPIResult.asSignal(onErrorJustReturn: false),
                      readyOneMin: readyOneMin.asSignal(onErrorJustReturn: ()),
                      callEnd: callEnd.asSignal(onErrorJustReturn: ()),
                      callFailThreeTime: callFailThreeTime.asSignal(onErrorJustReturn: ()),
                      outputState: outputState
        )
    }
    
    func socketBind() {
        var model: SetUserInModel!
        
        if UserDefaultsManager.shared.userType == "listener" {
            guard let matchedSpeaker = self.model?.first else { return }
            
            model = SetUserInModel(listenerId: matchedSpeaker.listenerId,
                                   channel: matchedSpeaker.channel,
                                   meetingTime: matchedSpeaker.meetingTime,
                                   speakerId: matchedSpeaker.speaker.id,
                                   isListener: true,
                                   channelId: matchedSpeaker.channelId)
        } else {
            model = SetUserInModel(listenerId: UserDefaultsManager.shared.listenerId,
                                   channel: UserDefaultsManager.shared.channel,
                                   meetingTime: UserDefaultsManager.shared.schedule,
                                   speakerId: UserDefaultsManager.shared.speakerId,
                                   isListener: false,
                                   channelId: UserDefaultsManager.shared.channelId)
            Log.d(model)
        }
        
        GLSocketManager.shared.connect{}
        
        GLSocketManager.shared.relays.socketConnection.bind(onNext: {
            if $0 {
                GLSocketManager.shared.setUserIn(model)
            }
        })
        .disposed(by: disposeBag)
        
        GLSocketManager.shared.relays.setUserIn.bind(onNext: { _ in
            if UserDefaultsManager.shared.userType == "listener" {
                GLSocketManager.shared.createChatRoom()
            } else {
                GLSocketManager.shared.enterChatRoom()
            }
        })
        .disposed(by: disposeBag)
        
        GLSocketManager.shared.relays.createChatRoom.bind(onNext: { _ in
            if UserDefaultsManager.shared.userType == "listener" {
                GLSocketManager.shared.enterChatRoom()
            }
        })
        .disposed(by: disposeBag)
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
