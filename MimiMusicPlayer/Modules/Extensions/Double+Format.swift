//
//  Double+Format.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 29.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

extension Double {
    var durationDisplay: String {
        let durationValue = Int(self)
       if durationValue > 3600 {
           return String(format: "%02d:%02d:%02d", durationValue / 3600, (durationValue % 3600) / 60, (durationValue % 3600) % 60)

       } else {
           return String(format: "%02d:%02d", durationValue / 60, durationValue % 60)
       }
    }
}
