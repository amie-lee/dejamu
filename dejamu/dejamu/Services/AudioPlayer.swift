//
//  AudioPlayer.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import AVFoundation
import Observation

@Observable
final class AudioPlayer {
    private(set) var playingTrackId: Int?
    private var player: AVPlayer?

    func toggle(trackId: Int, url: URL) {
        if playingTrackId == trackId {
            stop()
        } else {
            // .playback (vs. the default .soloAmbient) plays through the silent switch,
            // matching how Music's own preview playback behaves.
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try? AVAudioSession.sharedInstance().setActive(true)
            player = AVPlayer(url: url)
            player?.play()
            playingTrackId = trackId
        }
    }

    func stop() {
        player?.pause()
        player = nil
        playingTrackId = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}
