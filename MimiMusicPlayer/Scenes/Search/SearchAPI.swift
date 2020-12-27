//
//  SearchAPI.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 27.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
enum SearchAPI {
    case search(for: String)
}

extension SearchAPI: RequestBuilder {
    var method: HttpMethod {
        .get
    }

    var path: String {
        switch self {
        case .search:
            return "search/"
        }
    }

    var parameters: [String: Any] {
        switch self {
        case let .search(text):
            return ["t": text,
                    "page": "1",
                    "count": "20"]
        }
    }
}
