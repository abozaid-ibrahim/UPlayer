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

    @IBOutlet var viewHeightConstrain: NSLayoutConstraint!
    @IBOutlet private var fullPlayerContainer: UIView!
    @IBOutlet private var miniPlayerContainer: UIStackView!
    @IBOutlet private var playPauseBtn: UIButton!
    @IBOutlet private var artistLabel: UILabel!
    @IBOutlet private var songLable: UILabel!
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
        miniPlayerContainer.addGestureRecognizer(tapRecognizer)
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
        self.view.isHidden = false
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
        let fullScreen = FullScreenPlayerController(with: songWithPulses)
        addChild(fullScreen)
        fullPlayerContainer.addSubview(fullScreen.view)
        fullScreen.view.setConstrainsEqualToParentEdges()
        fullScreen.disappeared.subscribe(onNext: { _ in
            self.enableMiniScreenMode()
        }).disposed(by: fullScreen.disposeBag)
        enableFullScreenMode()
    }

    @objc private func enableFullScreenMode(sender: Any? = nil) {
        miniPlayerContainer.isHidden = true
        fullPlayerContainer.isHidden = false
        UIView.animate(withDuration: 1.2, animations: {
            self.viewHeightConstrain.constant = UIScreen.main.bounds.height - 20
        })
    }

    private func enableMiniScreenMode() {
        miniPlayerContainer.isHidden = false
        fullPlayerContainer.isHidden = true
        UIView.animate(withDuration: 1.2, animations: {
            self.viewHeightConstrain.constant = 90
        })
    }
}
