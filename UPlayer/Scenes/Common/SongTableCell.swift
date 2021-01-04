//
//  SongTableCell.swift
//  UPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Kingfisher
import UIKit

final class SongTableCell: UITableViewCell {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var avatarView: UIImageView!
    @IBOutlet private var genreLabel: UILabel!
    @IBOutlet private var durationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        avatarView.layer.borderColor = UIColor.systemGray.cgColor
    }

    func setData(for artist: PopulerTrack) {
        nameLabel.text = artist.username
        durationLabel.text = artist.duration
        genreLabel.text = artist.title
        avatarView.setImage(with: artist.avatar)
    }
}

extension SongTableCell {
    func setData(for song: Song) {
        nameLabel.text = song.title
        durationLabel.text = song.durationDisplay
        genreLabel.text = song.genre
        avatarView.setImage(with: song.thumb)
    }
}
