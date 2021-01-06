//
//  Destination.swift
//  UPlayer
//
//  Created by abuzeid on 19.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import DevPlayer
import Foundation
import UIKit

enum Destination {
    case fullScreenPlayer(song: Song, player: AudioPlayerType),
        songsList(for: Artist, and: [Song]),
        populerTracks

    var controller: UIViewController {
        switch self {
        case let .fullScreenPlayer(pulses, player):
            return FullScreenPlayerController(with: pulses, player: player)
        case let .songsList(artist, songs):
            return SongsListController(with: SongsViewModel(with: artist, and: songs))
        case .populerTracks:
            return PlayerContainerController()
        }
    }
}
