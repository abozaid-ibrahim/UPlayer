//
//  SongTableCell.swift
//  MimiMusicPlayer
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

    func setData(for artist: Artist) {
        nameLabel.text = artist.username
        durationLabel.text = artist.trackDuration
        genreLabel.text = artist.trackTitle
        avatarView.setImage(with: artist.avatarURL)
    }
}

extension SongTableCell {
    func setData(for song: Song) {
        nameLabel.text = song.title
        durationLabel.text = song.duration.durationDisplay
        genreLabel.text = song.genre
        avatarView.setImage(with: song.thumb)
    }
}
