//
//  Song.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 26.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

struct Song {
    let id: String
    let userID: String
    private let durationString: String
    let streamURL: URL
    let genre: String?
    let title: String?
    let thumb: URL?
    let waveformData: URL?
    let backgroundURL: URL?
    let user: Artist?
    var pulses: [Float] = []
}

extension Song {
    var duration: Double { Double(durationString) ?? 0 }
    var durationDisplay: String {
        DurationFromatter().display(duration: duration)
    }

    var uiUserModel: PopulerTrack? {
        return PopulerTrack(id: id,
                            userId: userID,
                            title: title,
                            duration: durationDisplay,
                            username: user?.username,
                            avatar: thumb)
    }
}

extension Song: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case durationString = "duration"
        case genre
        case title
        case thumb
        case waveformData = "waveform_data"
        case user
        case streamURL = "stream_url"
        case backgroundURL = "background_url"
    }
}
