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
}

final class SongsViewModel: SongsViewModelType {
    let songsList: BehaviorRelay<[Song]>
    private let disposeBag = DisposeBag()
    init(with songs: [Song]) {
        songsList = BehaviorRelay<[Song]>(value: songs)
    }
}

extension Song {
    var formattedDuration: String {
        guard let seconds = Int(duration) else { return "" }
        return String(format: "%02d:%02d:%02d", seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
