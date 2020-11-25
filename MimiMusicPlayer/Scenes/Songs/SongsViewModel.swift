//
//  SongsViewModel.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 25.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

typealias AudioPlayer = Void
protocol SongsViewModelType {
    var playSong: PublishRelay<Song> { get }
    var songsList: BehaviorRelay<[Song]> { get }
}

final class SongsViewModel: SongsViewModelType {
    let playSong = PublishRelay<Song>()
    let songsList: BehaviorRelay<[Song]>
    private let disposeBag = DisposeBag()
    private let player: AudioPlayer
    private let scheduler: SchedulerType
    private let allSongsListCache: [Song] = []
    init(with player: AudioPlayer = AudioPlayer(),
         songs: [Song],
         scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .default)) {
        self.player = player
        self.scheduler = scheduler
        songsList = BehaviorRelay<[Song]>(value: songs)
    }
}
