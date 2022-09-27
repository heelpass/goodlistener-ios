//
//  WebSocketManager.swift
//  GoodListener
//
//  Created by cheonsong on 2022/09/27.
//

import Foundation
import Starscream
import RxSwift
import RxCocoa

enum SocketEmitEvent: String {
    case setUserIn
    case enterChatRoom
    case disconnected
    case createChatRoom
    case createAgoraToken
}

class WebSocketManager {

    public static let shared = WebSocketManager()

    public var socket: WebSocket?
    public var responseSubject = PublishSubject<String>()

    private init() {
        let url = URL(string: "ws://223.130.162.39:5000")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
    }

    public func start() {
        socket?.connect()
    }

    func emit(from keyword: SocketEmitEvent) {
        if let socket = socket {
            socket.write(string: keyword.rawValue) // 2-1. write로 서버에 요청(데이터 전달)
        } else {
            print("webSocket is not connected")
        }
    }

    func disconnect() {
        if let socket = socket {
            socket.disconnect()
        } else {
            print("webSocket is not connected")
        }
    }

}

