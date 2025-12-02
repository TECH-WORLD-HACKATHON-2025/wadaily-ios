//
//  Agora.swift
//  Wadaily
//
//  Created by 浦山秀斗 on 2025/12/02.
//

import SwiftUI
import AgoraRtcKit
import Combine

// MARK: - Agora Manager
class AgoraManager: NSObject {
    var agoraKit: AgoraRtcEngineKit!
    
    init(delegate: AgoraRtcEngineDelegate) {
        // Info.plistからAgoraAppIdを取得
        guard let appId = Bundle.main.object(forInfoDictionaryKey: "AgoraAppId") as? String else {
            fatalError("AgoraAppId not found in Info.plist")
        }
        
        super.init()
        
        let config = AgoraRtcEngineConfig()
        config.appId = appId
        agoraKit = AgoraRtcEngineKit.sharedEngine(with: config, delegate: delegate)
        
        agoraKit.enableAudio()
        agoraKit.setChannelProfile(.communication)
    }
    
    func joinChannel(channelName: String, token: String? = nil, uid: UInt = 0) {
        let option = AgoraRtcChannelMediaOptions()
        option.channelProfile = .communication
        option.clientRoleType = .broadcaster
        
        agoraKit.joinChannel(
            byToken: token,
            channelId: channelName,
            uid: uid,
            mediaOptions: option
        )
    }
    
    func leaveChannel() {
        agoraKit.leaveChannel(nil)
    }
    
    func onMute() {
        agoraKit.muteLocalAudioStream(true)
    }
    
    func offMute() {
        agoraKit.muteLocalAudioStream(false)
    }
    
    deinit {
        AgoraRtcEngineKit.destroy()
    }
}
