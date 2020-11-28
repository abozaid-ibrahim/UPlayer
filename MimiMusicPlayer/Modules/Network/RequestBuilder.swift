//
//  APIClient.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

public protocol RequestBuilder {
    var path: String { get }

    var method: HttpMethod { get }

    var request: URLRequest? { get }

    var parameters: [String: Any] { get }
}

public enum HttpMethod: String {
    case get, post
}

extension RequestBuilder {
    var baseURL: String { "https://api-v2.hearthis.at/" }
}
