//
//  ArtistsListController.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit
protocol ArtistsViewModelType {
}

class ArtistsViewModel: ArtistsViewModelType {
}

final class ArtistsListController: UIViewController {
    private let tableView = UITableView()
    private let viewModel: ArtistsViewModelType
    init(with viewModel: ArtistsViewModelType = ArtistsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = .discover
    }

    override func loadView() {
        view = UIView()
        view.addSubview(tableView)
        tableView.accessibilityIdentifier = "ArtistsTable"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension String {
    static var discover: String { "Mimi".localizedCapitalized }
}
