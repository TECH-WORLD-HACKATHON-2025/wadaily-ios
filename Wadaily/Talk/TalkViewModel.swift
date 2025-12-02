//
//  TalkViewModel.swift
//  Wadaily
//
//  Created by 浦山秀斗 on 2025/12/03.
//

import Combine
import AgoraRtcKit

enum TalkViewState {
    case Before
    case Waiting
    case Talking
    case Talked
}

protocol AgoraEngineCoordinatorDelegate: AnyObject {
    func didJoinChannel(channelName: String)
    func didLeaveChannel()
    func didOccurError()
}

class TalkViewModel: ObservableObject {
    @Published var state: TalkViewState = .Before
    @Published var isMuted: Bool = false
    
    private var agoraManager: AgoraManager?
    private var coordinator: AgoraEngineCoordinator?
    
    init() {
        coordinator = AgoraEngineCoordinator(delegate: self)
        if let coordinator = coordinator {
            agoraManager = AgoraManager(delegate: coordinator)
        }
    }
    
    func joinChannel(channelName: String) {
        agoraManager?.joinChannel(channelName: channelName)
    }
    
    func leaveChannel() {
        agoraManager?.leaveChannel()
    }
    
    func toggleMute() {
        isMuted.toggle()
        if isMuted {
            agoraManager?.onMute()
        } else {
            agoraManager?.offMute()
        }
    }
}

extension TalkViewModel: AgoraEngineCoordinatorDelegate {
    func didJoinChannel(channelName: String) {
        state = .Talking
        print("Successfully joined channel: \(channelName)")
    }
    
    func didLeaveChannel() {
        state = .Talked
        print("Left channel")
    }
    
    func didOccurError() {
        state = .Before
        print("Error occurred")
    }
}

class AgoraEngineCoordinator: NSObject, AgoraRtcEngineDelegate {
    weak var delegate: AgoraEngineCoordinatorDelegate?
    
    init(delegate: AgoraEngineCoordinatorDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        delegate?.didJoinChannel(channelName: channel)
        print("Successfully joined channel: \(channel) with uid: \(uid)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        delegate?.didLeaveChannel()
        print("Left channel")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        delegate?.didOccurError()
        print("Error occurred: \(errorCode.rawValue)")
    }
}
