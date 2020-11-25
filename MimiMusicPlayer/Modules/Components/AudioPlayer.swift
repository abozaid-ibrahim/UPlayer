//
//  AudioPlayer.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 25.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import AVFoundation
import Foundation
import MobileCoreServices
import RxCocoa
import RxSwift
protocol AudioPlayerType {
}

final class AudioPlayer: NSObject, AudioPlayerType {
    private let disposeBag = DisposeBag()
    private var audioPlayer: AVPlayer?
    private var items: [AVPlayerItem] = []
    private var currentSongIndex = 0
    let state = BehaviorRelay<State>(value: .idle)
    static let shared = AudioPlayer()
    override private init() {
        /// Singleton
    }

    func playAudio(form list: [URL], startFrom: Int = 0) {
        currentSongIndex = startFrom
        items.removeAll()
        items = list.compactMap { AVPlayerItem(url: $0) }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            audioPlayer = AVPlayer(playerItem: items[startFrom])
            audioPlayer?.play()
            state.accept(.playing)
        } catch {
            state.accept(.error(error.localizedDescription))
        }
    }

    func stopAudio() {
        audioPlayer?.pause()
        state.accept(.idle)
    }

    func pauseAudio() {
        audioPlayer?.pause()
        state.accept(.paused)
    }

    func resume() {
        guard items.count > 0 else {
            return
        }
        audioPlayer?.play()
        state.accept(.playing)
    }

    func playNext() {
        guard (currentSongIndex + 1) < items.count else {
            return
        }
        currentSongIndex += 1
        audioPlayer?.replaceCurrentItem(with: items[currentSongIndex])
        audioPlayer?.play()
        state.accept(.playing)
    }

    func playPreviousTrack() {
        guard (currentSongIndex - 1) >= 0 else {
            return
        }
        currentSongIndex -= 1
        audioPlayer?.replaceCurrentItem(with: items[currentSongIndex])
        audioPlayer?.play()
        state.accept(.playing)
    }

    func togglePlayer() {
        switch state.value {
        case .playing:
            pauseAudio()
        case .paused:
            resume()
        default:
            print("TODO")
        }
    }

    enum State: Equatable {
        case playing
        case paused
        case idle
        case error(String)
        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case let (.error(lMsg), .error(item: rMsg)):
                return lMsg == rMsg
            case (.idle, .idle),
                 (.playing, .playing),
                 (.paused, .paused):
                return true
            default:
                return false
            }
        }
    }
}
