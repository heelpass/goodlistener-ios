//
//  CallManager.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/28.
//

import Foundation
import AgoraRtcKit
import RxSwift
import RxCocoa

struct AgoraConfiguration {
    
    static var appID          = "66619b6c1a2b46a4bec22f34aeb1840a"
    static var appCertificate = "90a05f9ed1724a608ca123eafa89703d"
//    static var customerkey    = "57ff1ee8000f46cfbdcc18734fe82c4e"
//    static var secret         = "7e5b372a213640ea863729887d2fc6d8"
    static var rtmToken       = "007eJxTYBB5+HfDsvdt/u9a+38sfL3um6vtVc1r87+ztJZxdjdNtq9VYDAzMzO0TDJLNkw0SjIxSzRJSk02MkozNklMTTK0MDFIdNjgl9wQyMiwylmDmZEBAkF8FgZDQ0sLBgYAQtIg3A=="
    static var channelName    = "1198"
}

class CallManager: NSObject {
    
    static let shared = CallManager()
    
    var agoraKit: AgoraRtcEngineKit?
    
    var enterSpeakerAndListener: PublishRelay<Void> = .init()
    
    private override init() {
        super.init()
        let config = AgoraRtcEngineConfig()
        config.appId = "66619b6c1a2b46a4bec22f34aeb1840a"
        agoraKit = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
    }
    
    func start(token: String, channelId: String, uid: Int, completion: ((String, UInt, Int) -> Void)? = nil) {
        // Join the channel with a token. Pass in your token and channel name here
        agoraKit?.joinChannel(byToken: token, channelId: channelId, info: nil, uid: 0, joinSuccess: completion)
        agoraKit?.setClientRole(.broadcaster)
    }
    
    func stop() {
        agoraKit?.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
    }
}

extension CallManager: AgoraRtcEngineDelegate {
    /// callback when warning occured for agora sdk, warning can usually be ignored, still it's nice to check out
    /// what is happening
    /// Warning code description can be found at:
    /// en: https://docs.agora.io/en/Voice/API%20Reference/oc/Constants/AgoraWarningCode.html
    /// cn: https://docs.agora.io/cn/Voice/API%20Reference/oc/Constants/AgoraWarningCode.html
    /// @param warningCode warning code of the problem
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        Log.d("agora :: warning: \(warningCode.rawValue)")
    }
    
    internal func rtcEngine(_ engine: AgoraRtcEngineKit, connectionChangedTo state: AgoraConnectionState, reason: AgoraConnectionChangedReason) {
        switch state {
        case .disconnected:
            Log.d("Agora state changed:: disconnected")
        case .connecting:
            Log.d("Agora state changed:: connecting")
        case .connected:
            Log.d("Agora state changed:: connected")
        case .reconnecting:
            Log.d("Agora state changed:: reconnecting")
        case .failed:
            Log.d("Agora state changed:: failed")
            Log.e(reason)
        @unknown default:
            Log.e(reason)
        }
    }
    
    /// callback when error occured for agora sdk, you are recommended to display the error descriptions on demand
    /// to let user know something wrong is happening
    /// Error code description can be found at:
    /// en: https://docs.agora.io/en/Voice/API%20Reference/oc/Constants/AgoraErrorCode.html
    /// cn: https://docs.agora.io/cn/Voice/API%20Reference/oc/Constants/AgoraErrorCode.html
    /// @param errorCode error code of the problem
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        Log.d("agora :: error: \(errorCode)")
    }
    
    /// callback when the local user joins a specified channel.
    /// @param channel
    /// @param uid uid of local user
    /// @param elapsed time elapse since current sdk instance join the channel in ms
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        Log.d("my join ")
        Log.d("agora :: Join \(channel) with uid \(uid) elapsed \(elapsed)ms")
    }
    
    /// callback when a remote user is joinning the channel, note audience in live broadcast mode will NOT trigger this event
    /// @param uid uid of remote joined user
    /// @param elapsed time elapse since current sdk instance join the channel in ms
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        Log.d("agora :: remote user join: \(uid) \(elapsed)ms")
        enterSpeakerAndListener.accept(())
    }
    
    /// callback when a remote user is leaving the channel, note audience in live broadcast mode will NOT trigger this event
    /// @param uid uid of remote joined user
    /// @param reason reason why this user left, note this event may be triggered when the remote user
    /// become an audience in live broadcasting profile
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        Log.d("agora :: remote user left: \(uid) reason \(reason)")
    }
}

