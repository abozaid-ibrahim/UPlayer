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
    @IBOutlet private var avatarView: UIImageView!
    @IBOutlet private var captionLabel: UILabel!
    @IBOutlet private var tracksLabel: UILabel!
    private var imageLoader: Disposable?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(for artist: Artist) {
        nameLabel.text = artist.username
        tracksLabel.text = String(artist.tracksCount)
        captionLabel.text = artist.caption
        imageLoader = avatarView.setImage(of: artist.avatarURL)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoader?.dispose()
        avatarView.image = nil
    }
}

extension ArtistTableCell {
    func setData(for song: Song) {
        nameLabel.text = song.title
        tracksLabel.text = song.formattedDuration
        captionLabel.text = song.genre
        imageLoader = avatarView.setImage(of: song.thumb)
    }
}
