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

// MARK: 1. 소켓으로 받을 이벤트 추가!!
enum SocketEvents: String {
    case userUpdates
    case userActivities
    case another
}

final class GLSocketManager: NSObject {
    
    // MARK: 2. 소켓으로 받을 이벤트를 넘겨줄 PublishRelay 선언
    // relay안에 [Any]는 데이터에 맞게끔 수정하면 됩니다!
    struct Relays {
        
        // Custom events:
        let user = PublishRelay<[Any]>()
        let activities = PublishRelay<[Any]>()
        let another = PublishRelay<[Any]>()
        
        // Socket events:
        /// Listen for socket connection changes.
        /// Relays `true` on `connected`, `false` on `disconnected`.
        let socketConnection = PublishRelay<Bool>()
    }
    
    static let shared = GLSocketManager()
    
    private var socketManager: SocketManager!
    public var socket: SocketIOClient!
    private let disposeBag = DisposeBag()
    
    // 공개적으로 접근 가능한 relays
    let relays = Relays()
    
    // 싱글톤으로 start메서드를 실행해주세요 소켓이 연결됩니다
    func start() {
        //
        guard socketManager == nil, let url = URL(string: "http://61.80.148.190:3000") else {
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
        socket = socketManager.defaultSocket
        addListeners()
        connect()
    }
    
    func addListeners() {
        // MARK: 3. 커스텀 이벤트를 리스너에 등록합니다!
        socket.listen(event: SocketEvents.userUpdates.rawValue, relay: relays.user)
        socket.listen(event: SocketEvents.userActivities.rawValue, relay: relays.activities)
        socket.listen(event: SocketEvents.another.rawValue, relay: relays.another)

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
