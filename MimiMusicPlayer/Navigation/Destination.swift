//
//  Destination.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

enum Destination {
    case artistsList
    case songsList([Song])
    var controller: UIViewController {
        switch self {
        case let .songsList(songs):
            return SongsListController(with: SongsViewModel(songs: songs))
        case .artistsList:
            return ArtistsListController()
        }
    }
}
