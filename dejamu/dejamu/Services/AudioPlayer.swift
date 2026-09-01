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
            player = AVPlayer(url: url)
            player?.play()
            playingTrackId = trackId
        }
    }

    func stop() {
        player?.pause()
        player = nil
        playingTrackId = nil
    }
}
