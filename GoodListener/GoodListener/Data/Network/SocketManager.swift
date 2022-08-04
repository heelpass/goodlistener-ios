//
//  SocketManager.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/03.
//

import Foundation
import SocketIO
import RxSwift
import RxCocoa

enum SocketEvents: String {
    // 사용자의 상태가 변경된 경우 -> Ex) 유저 닉네임 변경
    case userUpdates
    // 액션에 따른 UI 변경 및 기능 실행이 필요한 경우 -> Ex) 전화가 걸려온 상황에 전화 뷰를 올려줘야한다
    case userActivities
}

final class GLSocketManager: NSObject {
    struct Relays {
        // Custom events:
        /// User properties updated
        let user = PublishRelay<[Any]>()
        
        /// User activities added
        let activities = PublishRelay<[Any]>()
        
        // Socket events:
        /// Listen for socket connection changes.
        /// Relays `true` on `connected`, `false` on `disconnected`.
        let socketConnection = PublishRelay<Bool>()
    }
    
    static let shared = GLSocketManager()
    
    private var socketManager: SocketManager!
    private let disposeBag = DisposeBag()
    
    // Room 정보 입력 필요
    private var socket: SocketIOClient {
        return socketManager.socket(forNamespace: "/my-namespace")
    }
    
    // 공개적으로 접근 가능한 relays
    let relays = Relays()
    
    // 싱글톤으로 start메서드를 실행해주세요 소켓이 연결됩니다
    func start() {
        //
        guard socketManager == nil, let url = URL(string: "") else {
            return
        }
        
        // Initialize socket manager
        socketManager = SocketManager(
            socketURL: url,
            config: [
                .compress,
                .log(true)
            ]
        )
        
        addListeners()
        connect()
    }
    
    func addListeners() {
        // Custom Event를 MtsocketEvents 에 정의합니다
        // 예시로 작성해 논것이며 MySocketEvents 열거형에 이벤트를 작성해야 합니다
        socket.listen(event: SocketEvents.userUpdates.rawValue, relay: relays.user)
        socket.listen(event: SocketEvents.userActivities.rawValue, relay: relays.activities)

        // Connection 관리 relay.socketConnection을 구독하면 현재 소켓 연결 상태를 알 수 있다.
        socket.listen(event: SocketClientEvent.connect.rawValue, result: true, relay: relays.socketConnection)
        socket.listen(event: SocketClientEvent.disconnect.rawValue, result: false, relay: relays.socketConnection)
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
}

extension SocketIOClient {
    // 이벤트 발생 시 사용
    func listen(event: String, relay: PublishRelay<[Any]>) {
        on(event) { items, _ in
            relay.accept(items)
        }
    }
    
    // 해당 이벤트가 발생했을때 원하는 결과값을 넘겨줄때 사용
    func listen<T>(event: String, result: T, relay: PublishRelay<T>) {
        on(event) { _, _ in
            relay.accept(result)
        }
    }
}
