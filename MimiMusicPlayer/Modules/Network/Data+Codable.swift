//
//  Data+Codable.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
public extension Data {
    func parse<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}
