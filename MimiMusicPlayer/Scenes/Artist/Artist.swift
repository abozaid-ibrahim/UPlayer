//
//  Song.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

struct Artist {
    let id: String
    let username: String
    let caption: String?
    let avatarURL: URL?
}

extension Artist: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case caption
        case avatarURL = "avatar_url"
    }
}

extension Artist: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
