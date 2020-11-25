//
//  MiniPlayerViewController.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 25.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

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
        AudioPlayer.shared.state
            .map { UIImage(named: $0 == .playing ? "pause" : "play") }
            .bind(to: playPauseBtn.rx.image(for: .normal))
            .disposed(by: disposeBag)

        AudioPlayer.shared.state
            .map { $0 == .idle }
            .bind(to: view.rx.isHidden)
            .disposed(by: disposeBag)
    }

    @IBAction func togglePlayAction(_ sender: Any) {
        AudioPlayer.shared.togglePlayer()
    }
}

extension PlayerView: PlayerViewType {
    func play(song: Song) {
        guard let url = URL(string: song.streamURL) else { return }
        AudioPlayer.shared.playAudio(form: [url])
        artistLabel.text = song.user?.username
        songLable.text = song.title
    }
}
