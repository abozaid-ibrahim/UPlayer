//
//  MiniPlayerViewController.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 25.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Accelerate
import AVFoundation
import RxCocoa
import RxSwift
import UIKit

protocol PlayerViewType {
    func play(song: Song)
}

final class PlayerView: UIViewController {
    private let disposeBag = DisposeBag()
    @IBOutlet private var playPauseBtn: UIButton!
    @IBOutlet private var artistLabel: UILabel!
    @IBOutlet private var songLable: UILabel!
    private var fullScreenView: FullScreenPlayerController?

    static let shared = PlayerView()
    private init() {
        super.init(nibName: "PlayerView", bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(enableFullScreenMode(sender:)))
        view.addGestureRecognizer(tapRecognizer)
        AudioPlayer.shared.state
            .map { UIImage(named: $0 == .playing ? "pause_button" : "play_button") }
            .bind(to: playPauseBtn.rx.image(for: .normal))
            .disposed(by: disposeBag)
    }

    @IBAction func togglePlayAction(_ sender: Any) {
        AudioPlayer.shared.toggle()
    }
}

extension PlayerView: PlayerViewType {
    func play(song: Song) {
        AudioPlayer.shared.play(with: song.streamURL, duration: song.duration)
        artistLabel.text = song.user?.username
        songLable.text = song.title
        loadPulses(song)
    }

    private func loadPulses(_ song: Song) {
        song.loadPulses()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in self.setupFullScreen(song, $0) })
            .disposed(by: disposeBag)
    }

    private func setupFullScreen(_ song: Song, _ pulses: [Float]) {
        var songWithPulses = song
        songWithPulses.pulses = pulses
        fullScreenView = FullScreenPlayerController(with: songWithPulses)
        guard let controller = fullScreenView else {
            return
        }
        controller.modalPresentationStyle = .overCurrentContext
        present(controller, animated: true, completion: {
            self.view.isHidden = false
        })
    }

    @objc private func enableFullScreenMode(sender: Any? = nil) {
        guard let controller = fullScreenView else {
            return
        }
        present(controller, animated: true, completion: nil)
    }
}
