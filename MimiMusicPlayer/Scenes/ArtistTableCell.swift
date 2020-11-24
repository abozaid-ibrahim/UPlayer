//
//  ArtistTableCell.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class ArtistTableCell: UITableViewCell {
    @IBOutlet private var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(for artist: Artist) {
        nameLabel.text = artist.title
    }
}
