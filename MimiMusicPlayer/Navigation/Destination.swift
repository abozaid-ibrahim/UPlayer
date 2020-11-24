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
    case songsList
    var controller: UIViewController {
        switch self {
        case .songsList:
            return UIViewController()
        case .artistsList:
            return ArtistsListController()
        }
    }
}
