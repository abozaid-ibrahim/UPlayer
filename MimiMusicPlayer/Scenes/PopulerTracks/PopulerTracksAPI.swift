//
//  PopulerTracksAPI.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
enum PopulerTracksAPI {
    case populer(page: Page)
    case search(for: String)
}

extension PopulerTracksAPI: RequestBuilder {
    var path: String {
        switch self {
        case .populer:
            return "feed/"
        case .search:
            return "search/"
        }
    }

    var method: HttpMethod {
        return .get
    }

    var parameters: [String: Any] {
        switch self {
        case let .populer(page):
            return ["count": page.countPerPage,
                    "type": "popular",
                    "page": page.currentPage]
        case let .search(text):
            return ["t": text,
                    "page": "1",
                    "count": "20"]
        }
    }
}
