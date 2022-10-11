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
import SwiftyJSON


// MARK: 1. 소켓으로 받을 이벤트 추가!!
enum SocketEvents: String {
    case setUserIn
    case enterChatRoom
    case disconnected
    case createChatRoom
    case createAgoraToken

}

final class GLSocketManager: NSObject {

    // MARK: 2. 소켓으로 받을 이벤트를 넘겨줄 PublishRelay 선언
    // relay안에 [Any]는 데이터에 맞게끔 수정하면 됩니다!
    struct Relays {

        // Custom events:
        let setUserIn        = PublishRelay<[Any]>()   // JSON
        let enterChatRoom    = PublishRelay<[Any]>()   // String
        let disconnected     = PublishRelay<[Any]>()   // String
        let createChatRoom   = PublishRelay<[Any]>()   // String
        let createAgoraToken = PublishRelay<[Any]>()   // String

        // Socket events:
        /// Listen for socket connection changes.
        /// Relays `true` on `connected`, `false` on `disconnected`.
        let socketConnection = PublishRelay<Bool>()
    }

    static let shared = GLSocketManager()

    private var socketManager: SocketManager!
    public var socket: SocketIOClient!
    private let disposeBag = DisposeBag()
    
    var isConnected: Bool = false

    // 공개적으로 접근 가능한 relays
    let relays = Relays()
    
    private override init() {
        super.init()
        start()
    }

    // 싱글톤으로 start메서드를 실행해주세요 소켓이 연결됩니다
    func start() {
        //
        guard socketManager == nil, let url = URL(string: "ws://223.130.162.39:5000") else {
            return
        }

        // Initialize socket manager
        socketManager = SocketManager(
            socketURL: url,
            config: [
                .compress,
                .log(false)
            ]
        )
        socket = socketManager.defaultSocket
        addListeners()
        
//        socket.emit(SocketEvents.setUserIn.rawValue, [])
        relays.socketConnection.bind(onNext: {
            Log.d("SocketConnected:: \($0)")
            self.isConnected = $0
        })
        .disposed(by: disposeBag)
    }

    func addListeners() {
        // MARK: 3. 커스텀 이벤트를 리스너에 등록합니다!
        socket.listen(event: SocketEvents.setUserIn.rawValue, relay: relays.setUserIn)
        socket.listen(event: SocketEvents.enterChatRoom.rawValue, relay: relays.enterChatRoom)
        socket.listen(event: SocketEvents.disconnected.rawValue, relay: relays.disconnected)
        socket.listen(event: SocketEvents.createChatRoom.rawValue, relay: relays.createChatRoom)
        socket.listen(event: SocketEvents.createAgoraToken.rawValue, relay: relays.createAgoraToken)

        // Connection 관리 relay.socketConnection을 구독하면 현재 소켓 연결 상태를 알 수 있다.
        socket.listen(event: SocketClientEvent.connect.rawValue, result: true, relay: relays.socketConnection)
        socket.listen(event: SocketClientEvent.disconnect.rawValue, result: false, relay: relays.socketConnection)
    }

    func connect(completion: (()->Void)?) {
        socket.connect(timeoutAfter: 5.0, withHandler: completion)
    }

    func disconnect() {
        socket.disconnect()
    }
    
    func setUserIn(_ data: SetUserInModel) {
        do {
            let model = try data.socketRepresentation()
            socket.emit(SocketEvents.setUserIn.rawValue, model)
        } catch {
            return
        }
    }
    
    func createChatRoom() {
        socket.emit(SocketEvents.createChatRoom.rawValue, "a")
    }
    
    func enterChatRoom() {
        socket.emit(SocketEvents.enterChatRoom.rawValue, "a")
    }
    
    func createAgoraToken() {
        socket.emit(SocketEvents.createAgoraToken.rawValue, "a")
    }
    
    func disconnected() {
        socket.emit(SocketEvents.disconnected.rawValue, "a")
    }
}

extension SocketIOClient {
    // 이벤트 발생 시 사용
    func listen(event: String, relay: PublishRelay<[Any]>) {
        on(event) { items, _ in
            relay.accept(items)
            Log.d("Socket \(event):: \(items)")
        }
    }

    // 해당 이벤트가 발생했을때 원하는 결과값을 넘겨줄때 사용
    func listen<T>(event: String, result: T, relay: PublishRelay<T>) {
        on(event) { _, _ in
            relay.accept(result)
        }
    }
}
