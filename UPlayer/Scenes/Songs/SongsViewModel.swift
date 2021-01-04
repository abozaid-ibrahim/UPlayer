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
}

final class SongsViewModel: SongsViewModelType {
    let songsList: BehaviorRelay<[Song]>
    let artist: Artist
    init(with artist: Artist, and songs: [Song]) {
        songsList = BehaviorRelay<[Song]>(value: songs)
        self.artist = artist
    }
}

extension Song {
    func loadPulses() -> Observable<[Float]> {
        guard let url = waveformData else { return Observable.empty() }
        return URLSession.shared.rx.data(request: .init(url: url))
            .map { try JSONDecoder().decode([Float].self, from: $0) }
            .compactMap { $0.map { $0 / 500 }}
    }
}
