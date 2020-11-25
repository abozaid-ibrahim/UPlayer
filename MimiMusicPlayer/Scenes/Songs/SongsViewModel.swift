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

protocol SongsViewModelType {
    var playSong: PublishRelay<Song> { get }
    var songsList: BehaviorRelay<[Song]> { get }
}

final class SongsViewModel: SongsViewModelType {
    let playSong = PublishRelay<Song>()
    let songsList: BehaviorRelay<[Song]>
    private let disposeBag = DisposeBag()
    private let player: AudioPlayer
    private let allSongsListCache: [Song] = []
    init(with player: AudioPlayer = AudioPlayer.shared,
         songs: [Song]) {
        self.player = player
        songsList = BehaviorRelay<[Song]>(value: songs)
    }
}
