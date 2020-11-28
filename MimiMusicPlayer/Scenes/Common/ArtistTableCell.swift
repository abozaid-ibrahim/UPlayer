//
//  ArtistTableCell.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Kingfisher
import UIKit

final class ArtistTableCell: UITableViewCell {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var avatarView: UIImageView!
    @IBOutlet private var captionLabel: UILabel!
    @IBOutlet private var tracksLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        avatarView.layer.borderColor = UIColor.systemGray.cgColor
    }

    func setData(for artist: Artist) {
        nameLabel.text = artist.username
        tracksLabel.text = ""
        captionLabel.text = artist.caption
        avatarView.setImage(with: artist.avatarURL)
    }
}

extension ArtistTableCell {
    func setData(for song: Song) {
        nameLabel.text = song.title
        tracksLabel.text = song.formattedDuration
        captionLabel.text = song.genre
        avatarView.setImage(with: song.thumb)
    }
}
