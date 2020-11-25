//
//  Song.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

struct Song: Codable {
    let id: String
    let restaurantsResponsePrivate, releaseDate: String?
    let releaseTimestamp: Int?
    let userID: String
    let duration: String
    let permalink, restaurantsResponseDescription: String?
    let geo, tags, tagedArtists, bpm: String?
    let key, license, version, type: String?
    let genre, genreSlush, title: String?
    let uri, permalinkURL: String?
    let thumb, artworkURL, artworkURLRetina, backgroundURL: String?
    let waveformData: String?
    let waveformURL: String?
    let user: Artist?
    let streamURL: String?
    let previewURL: String?
    let downloadURL, downloadFilename: String?
    let played, favorited, liked, reshared: Bool?
    enum CodingKeys: String, CodingKey {
        case id
        case restaurantsResponsePrivate = "private"
        case releaseDate = "release_date"
        case releaseTimestamp = "release_timestamp"
        case userID = "user_id"
        case duration, permalink
        case restaurantsResponseDescription = "description"
        case geo, tags
        case tagedArtists = "taged_artists"
        case bpm, key, license, version, type, genre
        case genreSlush = "genre_slush"
        case title, uri
        case permalinkURL = "permalink_url"
        case thumb
        case artworkURL = "artwork_url"
        case artworkURLRetina = "artwork_url_retina"
        case backgroundURL = "background_url"
        case waveformData = "waveform_data"
        case waveformURL = "waveform_url"
        case user
        case streamURL = "stream_url"
        case previewURL = "preview_url"
        case downloadURL = "download_url"
        case downloadFilename = "download_filename"
        case played, favorited, liked, reshared
    }
}

// MARK: - User

struct Artist: Codable {
    let id: String
    let permalink, username, caption: String?
    let uri, permalinkURL: String?
    let avatarURL: String?
    var tracksCount: Int = 0

    enum CodingKeys: String, CodingKey {
        case id, permalink, username, caption, uri
        case permalinkURL = "permalink_url"
        case avatarURL = "avatar_url"
    }
}
