//
//  FullScreenPlayerController.swift
//  UPlayer
//
//  Created by abuzeid on 29.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class FullScreenPlayerController: UIViewController {
    @IBOutlet private var coverScrollView: UIScrollView!
    @IBOutlet private var coverImageView: UIImageView!
    @IBOutlet private var durationView: DurationLabel!
    @IBOutlet private var ownerNameLabel: UILabel!
    @IBOutlet private var songNameLabel: UILabel!
    @IBOutlet private var playButton: UIButton!
    @IBOutlet private var waveContainer: UIView!
    private let disposeBag = DisposeBag()
    private let song: Song
    private let player: AudioPlayerType
    private var isScrolling = false
    private var songWaveViewController: SongWaveViewController!

    init(with song: Song, player: AudioPlayerType) {
        self.song = song
        self.player = player
        super.init(nibName: "FullScreenPlayerController", bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(frame: self.view.frame)
        blurView.effect = blurEffect
        blurView.isHidden = true
        blurView.alpha = 0.9
        return blurView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        enableSwipeToHide()
        setupUI()
        addWaveScrollController()
        setupDidTapGesture()
        player.audioProgress
            .subscribe(onNext: { [unowned self] in self.setPlayer(progress: $0) })
            .disposed(by: disposeBag)
        view.insertSubview(blurEffectView, aboveSubview: coverScrollView)
    }

    func addWaveScrollController() {
        songWaveViewController = SongWaveViewController(with: song)
        songWaveViewController.delegate = self
        addChild(songWaveViewController)
        waveContainer.addSubview(songWaveViewController.view)
        songWaveViewController.view.setConstrainsEqualToParentEdges()
    }
}

private extension FullScreenPlayerController {
    func setupUI() {
        coverImageView.setImage(with: song.backgroundURL)
        durationView.setDuration(for: song.durationDisplay)
        ownerNameLabel.text = song.user?.username
        songNameLabel.text = song.title
        playButton.isHidden = true
    }

    func setupDidTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func didTapOnView() {
        playButton.isHidden.toggle()
        blurEffectView.isHidden.toggle()
        songWaveViewController.toggleWave()
        player.toggle()
    }

    func setPlayer(progress: Double) {
        guard !isScrolling else { return }
        isScrolling = false
        updateCoverScrollView(CGFloat(progress))
        updateWave(CGFloat(progress * 2))
        durationView.updateTime(with: CGFloat(progress), for: song.duration)
    }
}

extension FullScreenPlayerController: SongWaveViewDelegate {
    func songWaveView(didScroll percentage: CGFloat) {
        durationView.updateTime(with: percentage, for: song.duration)
        updateCoverScrollView(CGFloat(percentage))

        if player.state.value == .paused && blurEffectView.isHidden {
            player.resume(to: Double(percentage))
        }
    }

    func songWaveView(willBeginDragging: Bool, percentage: CGFloat) {
        guard willBeginDragging else { return }
        isScrolling = true
        durationView.animate(scale: true)
        updatePlayButtonVisibility(hide: true)
    }

    func songWaveView(percentage: CGFloat) {
        durationView.animate(scale: true)
        updatePlayButtonVisibility(hide: true)
    }

    func songWaveView(didEndDragging: Bool, percentage: CGFloat) {
        guard didEndDragging else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.durationView.animate(scale: false)
        }
        updatePlayButtonVisibility(hide: false)
        updateAudioPlayer(percentage)
        isScrolling = false
    }

    private func updateCoverScrollView(_ percentage: CGFloat) {
        let newXpoint = (coverScrollView.contentSize.width - coverScrollView.frame.size.width) * percentage
        coverScrollView.contentOffset = CGPoint(x: newXpoint, y: 0.0)
    }

    private func updateWave(_ percentage: CGFloat) {
        songWaveViewController.updateWave(percentage: percentage)
    }

    private func updateAudioPlayer(_ percentage: CGFloat) {
        player.seek(to: Double(percentage))
    }

    private func updatePlayButtonVisibility(hide: Bool) {
        guard !blurEffectView.isHidden else {
            return
        }
        playButton.isHidden.toggle()
    }
}
