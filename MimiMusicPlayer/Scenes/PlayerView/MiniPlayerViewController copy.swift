//
//  MiniPlayerViewController.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import UIKit

/// mini view appears at the bottom of the application to show audio controls to the current song
final class MiniPlayerViewController: UIViewController {
    private let disposeBag = DisposeBag()

    // MARK: Outlets

    @IBOutlet private var playPauseBtn: UIImageView!
    @IBOutlet private var forwardBtn: UIImageView!
    @IBOutlet private var backwardBtn: UIImageView!
    @IBOutlet private var titleLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    /// bind view attributes to view model
    private func bind() {
        AudioPlayer.shared.state
            .bind(onNext: updateIcon(for:)).disposed(by: disposeBag)
        AudioPlayer.shared.playPause(playPauseBtn.rx.tapGesture().asObservable())
    }

    /// update mini player icons according to state recieved from the audio player
    /// - Parameter state: the new state of the audio player
    private func updateIcon(for state: AudioPlayer.State) {
        switch state {
        case let .playing(item):
            playPauseBtn.image = UIImage(named: "pauseIcon")
            titleLbl.text = item.title
        case let .paused(item):
            playPauseBtn.image = UIImage(named: "playicon")
            titleLbl.text = item.title
        default:
            playPauseBtn.image = nil
        }
    }
}
