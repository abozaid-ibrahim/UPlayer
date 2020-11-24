//
//  ActivityIndicatorView.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class ActivityIndicatorView: UIView {
    private let activityView: UIActivityIndicatorView
    override init(frame: CGRect) {
        if #available(iOS 13, *) {
            activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        } else {
            activityView = UIActivityIndicatorView(style: .gray)
        }
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    static var identifier: String {
        return String(describing: self)
    }

    func set(isLoading: Bool) {
        if isLoading {
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
        }
    }

    private func setup() {
        addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            activityView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityView.centerXAnchor.constraint(equalTo: centerXAnchor)])
    }
}

extension UITableView {
    func isLoading(_ loading: Bool) {
        (tableHeaderView as? ActivityIndicatorView)?.set(isLoading: loading)
        sizeHeaderToFit(loading)
    }

    func sizeHeaderToFit(_ loading: Bool) {
        guard let headerView = tableHeaderView else { return }
        var frame = headerView.frame
        frame.size.height = loading ? 80 : 0
        headerView.frame = frame
        tableHeaderView = headerView
    }
}
