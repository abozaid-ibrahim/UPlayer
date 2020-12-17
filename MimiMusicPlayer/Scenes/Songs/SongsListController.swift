//
//  SongsListController.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 25.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class SongsListController: UIViewController {
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
    private let viewModel: SongsViewModelType
    init(with viewModel: SongsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = UIView()
        view.addSubview(tableView)
        tableView.accessibilityIdentifier = "SongsTable"
        tableView.setConstrainsEqualToParentEdges()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindToViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true

    }
}

private extension SongsListController {
    func setupTableView() {
        tableView.rowHeight = 65
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = SongsViewHeader(with: viewModel.artist)
        tableView.sizeHeaderToFit()
        tableView.register(SongTableCell.self)
        tableView.showsVerticalScrollIndicator = true
        navigationController?.hidesBarsOnSwipe = false
    }

    func bindToViewModel() {
        viewModel.songsList
            .bind(to: tableView.rx
                .items(cellIdentifier: SongTableCell.identifier,
                       cellType: SongTableCell.self)) { _, model, cell in
                cell.setData(for: model)
            }.disposed(by: disposeBag)

        tableView.rx.modelSelected(Song.self)
            .subscribe(onNext: { [unowned self] in
                self.play($0)
            }).disposed(by: disposeBag)
    }

    func play(_ song: Song) {
        PlayerView.shared.play(song: song)
    }
}
