//
//  PopulerTrack.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 08.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

struct PopulerTrack {
    let id: String
    let userId: String
    let title: String?
    let duration: String
    let username: String?
    let avatar: URL?
}

extension PopulerTrack: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
