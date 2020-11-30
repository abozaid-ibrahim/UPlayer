//
//  SongsViewHeader.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 28.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

final class SongsViewHeader: UIView {
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()

    lazy var avatarView: UIImageView = {
        let view = UIImageView()
        view.cornerRadius = 50
        view.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.addConstraints([
            view.heightAnchor.constraint(equalToConstant: 100),
            view.widthAnchor.constraint(equalTo: view.heightAnchor)])
        return view
    }()

    lazy var space: UIView = {
        let view = UIView()
        view.addConstraint(view.heightAnchor.constraint(equalToConstant: 8))
        return view
    }()

    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        return label
    }()

    func setup() {
        addSubview(stack)
        stack.setConstrainsEqualToParentEdges()
        stack.addArrangedSubview(avatarView)
        stack.addArrangedSubview(usernameLabel)
        stack.addArrangedSubview(captionLabel)
        stack.addArrangedSubview(space)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    init(with artist: Artist) {
        super.init(frame: .zero)
        setup()
        avatarView.setImage(with: artist.avatarURL)
        captionLabel.text = artist.caption
        usernameLabel.text = artist.username
    }
}
