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
    var state: BehaviorRelay<State> { get }
    var audioProgress: PublishRelay<Double> { get }
    func play(with url: URL, duration: Double)
    func pause()
    func toggle()
    func seek(to percentage: Double)
    func resume(to percentage: Double)
}

final class AudioPlayer: NSObject, AudioPlayerType {
    let audioProgress =  PublishRelay<Double>()
    private let disposeBag = DisposeBag()
    private var player: AVPlayer!
    let state = BehaviorRelay<State>(value: .idle)
    static let shared = AudioPlayer()
    private var timeObserverToken: Any?

    override private init() {
        // Singleton
    }

    func play(with url: URL, duration: Double) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = AVPlayer(playerItem: AVPlayerItem(url: url))
            player?.play()
            state.accept(.playing)

            let timeScale = CMTimeScale(NSEC_PER_SEC)
            let time = CMTime(seconds: 0.2, preferredTimescale: timeScale)

            timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
                guard let self = self else { return }
                let cprogress = time.seconds / duration
                if self.state.value == .playing {
                    self.audioProgress.accept(cprogress)
                }

//                if time.seconds >= duration {
//                    self.state.accept(.paused)
//                } else {
//                    self.state.accept(.paused)
//                }
            }
        } catch {
            print(error)
            state.accept(.error(error.localizedDescription))
        }
    }

    func stop() {
        player?.pause()
        state.accept(.idle)
    }

    func pause() {
        player?.pause()
        state.accept(.paused)
    }

    func resume() {
        player?.play()
        state.accept(.playing)
    }

    func toggle() {
        switch state.value {
        case .playing:
            pause()
        case .paused:
            resume()
        default:
            print("TODO")
        }
    }

    func seek(to percentage: Double) {
        let duration = player.currentItem?.duration.seconds ?? 0
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: duration * percentage, preferredTimescale: timeScale)
        self.audioProgress.accept(percentage)
        player.seek(to: time)
    }

    func resume(to percentage: Double) {
        state.accept(.playing)
        seek(to: percentage)
        player.play()
    }

    deinit {
        self.timeObserverToken = nil
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
