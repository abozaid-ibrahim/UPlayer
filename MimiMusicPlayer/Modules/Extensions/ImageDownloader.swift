//
//  ImageDownloader.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit
extension UIImageView {
    func setImage(with url: URL?) {
        kf.setImage(with: url)
    }
}
