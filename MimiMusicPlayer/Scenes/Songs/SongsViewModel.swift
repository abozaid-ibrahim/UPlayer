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
    var songsList: BehaviorRelay<[Song]> { get }
    var artist: Artist { get }
}

final class SongsViewModel: SongsViewModelType {
    let songsList: BehaviorRelay<[Song]>
    private let disposeBag = DisposeBag()
    let artist: Artist
    init(with artist: Artist, and songs: [Song]) {
        songsList = BehaviorRelay<[Song]>(value: songs)
        self.artist = artist
    }
}
