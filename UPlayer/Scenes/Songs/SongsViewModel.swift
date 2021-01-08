//
//  SongsViewModel.swift
//  UPlayer
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
    func loadPulses(of song: Song) -> Observable<Song>
}

final class SongsViewModel: SongsViewModelType {
    let songsList: BehaviorRelay<[Song]>
    let artist: Artist
    init(with artist: Artist, and songs: [Song]) {
        songsList = BehaviorRelay<[Song]>(value: songs)
        self.artist = artist
    }

    func loadPulses(of song: Song) -> Observable<Song> {
        guard let url = song.waveformData else { return Observable.of(song) }
        return URLSession.shared.rx.data(request: .init(url: url))
            .compactMap { let puls = $0.map { Float($0) / 500 }
                var songWithPulses = song
                songWithPulses.pulses = puls
                return songWithPulses
            }
    }
}
