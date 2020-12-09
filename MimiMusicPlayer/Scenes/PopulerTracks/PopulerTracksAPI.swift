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
}

extension PopulerTracksAPI: RequestBuilder {
    var path: String {
        switch self {
        case .populer:
            return "feed/"
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
        }
    }
}
