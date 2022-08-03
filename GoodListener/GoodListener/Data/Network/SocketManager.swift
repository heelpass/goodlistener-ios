//
//  SocketManager.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/03.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    
    var manager = SocketManager(socketURL: URL(string: "!!!URL!!!")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    override init() {
        super.init()
        socket = self.manager.socket(forNamespace: "/test") // "/test -> Room 서버쪽이랑 맞춰야함
        
        receiveEvent()
    }
    
    // socket 연결 시도
    func establishConnection() {
        socket.connect()
    }
    
    // socket 연결 종료
    func closeConnection() {
        socket.disconnect()
    }
    
    // socket 이벤트 받는 함수
    func receiveEvent() {
        socket.on("test") { dataArray, ack in
            print(dataArray)
        }
    }
    
    func sendMessage(message: String, nickname: String) {

    }
}
