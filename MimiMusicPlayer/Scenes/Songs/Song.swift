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
    let genre, title: String?
    let thumb: URL?
    let waveformData: URL?
    let backgroundURL: URL?
    let user: Artist?
    var pulses: [Float] = []
}

import AVFoundation

extension Song {
    init(id: String, uid: String, duration: String, stream: URL, waveform: URL) {
        self.id = id
        userID = uid
        durationString = duration
        streamURL = stream
        waveformData = waveform
        user = nil
        thumb = nil
        genre = nil
        title = nil
        backgroundURL = nil
    }

    var duration: Double { Double(durationString) ?? 0 }
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

import RxSwift
extension Song {
    func loadPulses() -> Observable<[Float]> {
        guard let url = waveformData else { return Observable.empty() }
        return URLSession.shared.rx.data(request: .init(url: url))
            .map { try JSONDecoder().decode([Float].self, from: $0) }
    }
}
