//
//  SongWaveViewController.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 29.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//
import RxSwift
import UIKit

protocol SongWaveViewDelegate: class {
    func songWaveView(didScroll percentage: CGFloat)
    func songWaveView(willBeginDragging: Bool, percentage: CGFloat)
    func songWaveView(percentage: CGFloat)
    func songWaveView(didEndDragging: Bool, percentage: CGFloat)
}

final class SongWaveViewController: UIViewController {
    @IBOutlet private var leftWaveView: UIView!
    @IBOutlet private var rightWaveView: UIView!
    @IBOutlet private var waveScrollView: UIScrollView!
    @IBOutlet private var waveContainerView: UIView!
    private let disposeBag = DisposeBag()
    weak var delegate: SongWaveViewDelegate?
    private var songWave: SongWave!
    private let song: Song

    init(with song: Song) {
        self.song = song
        super.init(nibName: "SongWaveViewController", bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func toggleWave() {
        songWave.isActive.toggle()
        songWave.setNeedsDisplay()
    }

    func updateWave(percentage: CGFloat) {
        var newXpoint = (waveScrollView.contentSize.width - waveScrollView.frame.size.width) * percentage
        newXpoint -= waveScrollView.contentInset.left
        waveScrollView.contentOffset = CGPoint(x: newXpoint, y: 0.0)
    }
}

private extension SongWaveViewController {
    func setup() {
        createWaveView()
        setupWaveScrollView()
        setWaveBackgroundColorPattern()
    }

    func createWaveView() {
        let size = CGSize(width: view.frame.width * 2, height: waveScrollView.frame.height)
        let frame = CGRect(origin: view.frame.origin, size: size)
        songWave = SongWave(frame: frame)
        songWave.pulses = song.pulses
        songWave.setNeedsDisplay()
        songWave.backgroundColor = .clear
    }

    func setupWaveScrollView() {
        waveScrollView.decelerationRate = UIScrollView.DecelerationRate.fast

        waveScrollView.addSubview(songWave)
        waveScrollView.backgroundColor = .clear
        waveScrollView.frame = songWave.frame

        waveScrollView.contentInset = UIEdgeInsets(top: 0.0,
                                                   left: view.frame.size.width / 2.0,
                                                   bottom: 0.0,
                                                   right: view.frame.size.width / 2.0)
        waveScrollView.contentSize = songWave.frame.size
        waveScrollView.delegate = self
    }

    func setWaveBackgroundColorPattern() {
        leftWaveView.backgroundColor = UIColor(patternImage: UIImage(named: "leftWave_gradient")!)
        rightWaveView.backgroundColor = UIColor(patternImage: UIImage(named: "rightWave_gradient")!)
        waveContainerView.mask = waveScrollView
    }
}

extension SongWaveViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        waveScrollView.contentOffset = scrollView.contentOffset
        let offsetPercentage = (scrollView.contentOffset.x + scrollView.contentInset.left) / scrollView.contentSize.width
        delegate?.songWaveView(didScroll: offsetPercentage)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        waveScrollView.contentOffset = scrollView.contentOffset
        let offsetPercentage = (scrollView.contentOffset.x + scrollView.contentInset.left) / scrollView.contentSize.width
        delegate?.songWaveView(willBeginDragging: true, percentage: offsetPercentage)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        waveScrollView.contentOffset = scrollView.contentOffset
        let offsetPercentage = (scrollView.contentOffset.x + scrollView.contentInset.left) / scrollView.contentSize.width
        delegate?.songWaveView(percentage: offsetPercentage)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        waveScrollView.contentOffset = scrollView.contentOffset
        let offsetPercentage = (scrollView.contentOffset.x + scrollView.contentInset.left) / scrollView.contentSize.width
        delegate?.songWaveView(didEndDragging: true, percentage: offsetPercentage)
    }
}
