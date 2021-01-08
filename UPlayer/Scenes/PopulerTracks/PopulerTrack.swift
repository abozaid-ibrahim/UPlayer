//
//  PopulerTrack.swift
//  UPlayer
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

extension PopulerTrack {
    init(from song: Song) {
        id = song.id
        userId = song.userID
        title = song.title
        duration = song.durationDisplay
        username = song.user?.username
        avatar = song.thumb
    }
}

extension PopulerTrack: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
