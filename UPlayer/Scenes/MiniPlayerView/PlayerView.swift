//
//  MiniPlayerViewController.swift
//  UPlayer
//
//  Created by abuzeid on 25.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Accelerate
import AVFoundation
import DevPlayer
import RxCocoa
import RxSwift
import UIKit

protocol PlayerViewType {
    func play(song: Song)
    func showFullScreenPlayer(for song: Song)
}

final class PlayerView: UIViewController {
    private let disposeBag = DisposeBag()
    @IBOutlet private var playPauseBtn: UIButton!
    @IBOutlet private var artistLabel: UILabel!
    @IBOutlet private var songLable: UILabel!
    private var fullScreenView: FullScreenPlayerController?
    private let player: AudioPlayerType = AudioPlayer.shared
    static let shared = PlayerView()
    private init() {
        super.init(nibName: "PlayerView", bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(enableFullScreenMode(sender:)))
        view.addGestureRecognizer(tapRecognizer)
        player.state
            .map { UIImage(named: $0 == .playing ? "pause_button" : "play_button") }
            .bind(to: playPauseBtn.rx.image(for: .normal))
            .disposed(by: disposeBag)
    }
}

private extension PlayerView {
    @IBAction private func togglePlayAction(_: Any) {
        player.toggle()
    }

    func setupFullScreen(_ song: Song) {
        AppNavigator.shared
            .presentModally(.fullScreenPlayer(song: song, player: player),
                            onComplete: { [weak self] in self?.view.isHidden = false })
    }

    @objc func enableFullScreenMode(sender _: Any? = nil) {
        guard let controller = fullScreenView else {
            return
        }
        present(controller, animated: true, completion: nil)
    }
}

extension PlayerView: PlayerViewType {
    func play(song: Song) {
        player.play.accept((url: song.streamURL, duration: song.duration))
        artistLabel.text = song.user?.username
        songLable.text = song.title
    }

    func showFullScreenPlayer(for song: Song) {
        setupFullScreen(song)
    }
}
