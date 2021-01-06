//
//  PopulerTracksAPI.swift
//  UPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import DevNetwork
import Foundation

enum PopulerTracksAPI {
    case populer(page: Page)
}

extension PopulerTracksAPI: RequestBuilder {
    var baseURL: String {
        "https://api-v2.hearthis.at/"
    }

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
            return ["count": page.size,
                    "type": "popular",
                    "page": page.size]
        }
    }
}
