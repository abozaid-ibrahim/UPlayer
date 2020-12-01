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
    let audioProgress = PublishRelay<Double>()
    let state = BehaviorRelay<State>(value: .idle)
    private let disposeBag = DisposeBag()
    private var player: AVPlayer?

    func play(with url: URL, duration: Double) {
        let item = AVPlayerItem(url: url)
        guard player == nil else {
            playCurrent(item: item)
            return
        }
        player = AVPlayer(playerItem: item)
        player?.rx.error
            .filter { $0 != nil }
            .bind(onNext: { [unowned self] in self.state.accept(.error($0?.localizedDescription ?? "")) })
            .disposed(by: disposeBag)
        setPlaybackActive()
        playCurrent(item: item)
        updateProgress(with: duration)
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
        if state.value == .playing {
            pause()
        } else if state.value == .paused {
            resume()
        }
    }

    func seek(to percentage: Double) {
        guard let player = player else { return }
        let duration = player.currentItem?.duration.seconds ?? 0
        let time = CMTime(seconds: duration * percentage, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.seek(to: time)
    }

    func resume(to percentage: Double) {
        guard let player = player else { return }
        state.accept(.playing)
        seek(to: percentage)
        player.play()
    }
}

private extension AudioPlayer {
    func playCurrent(item: AVPlayerItem) {
        player?.replaceCurrentItem(with: item)
        player?.play()
        state.accept(.playing)
    }

    func setPlaybackActive() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            state.accept(.error(error.localizedDescription))
        }
    }

    func updateProgress(with duration: Double) {
        player?.rx.periodicTimeObserver(interval: CMTime(seconds: 0.2, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
            .distinctUntilChanged()
            .map { $0.seconds / duration }
            .bind(to: audioProgress)
            .disposed(by: disposeBag)
    }
}
