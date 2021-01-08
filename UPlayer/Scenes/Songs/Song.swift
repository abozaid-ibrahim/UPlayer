//
//  Song.swift
//  UPlayer
//
//  Created by abuzeid on 26.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import DevPlayer
import Foundation

struct Song {
    let id: String
    let userID: String
    let durationString: String
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
