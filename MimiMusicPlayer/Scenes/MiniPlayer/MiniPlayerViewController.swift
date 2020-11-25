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

final class MiniPlayerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    @IBOutlet private var playPauseBtn: UIButton!
    @IBOutlet private var artistLabel: UILabel!
    @IBOutlet private var songLable: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        AudioPlayer.shared.state
            .bind(onNext: updateIcon(for:))
            .disposed(by: disposeBag)
        
        AudioPlayer.shared.state
            .map { $0 == .idle }
            .bind(to: view.rx.isHidden)
            .disposed(by: disposeBag)
    }

    @IBAction func togglePlayAction(_ sender: Any) {
        AudioPlayer.shared.togglePlayer()
    }

    @IBAction func closeAction(_ sender: Any) {
        AudioPlayer.shared.stopAudio()
    }

    private func updateIcon(for state: AudioPlayer.State) {
        let image = state == .playing ? "pause" : "play"
        playPauseBtn.setImage(UIImage(named: image), for: .normal)
    }
}
