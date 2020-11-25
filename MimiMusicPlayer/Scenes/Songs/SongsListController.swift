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
        title = .discover
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
}

private extension SongsListController {
    func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(ArtistTableCell.self)
        tableView.showsVerticalScrollIndicator = true
        navigationController?.hidesBarsOnSwipe = false
    }

    func bindToViewModel() {
        viewModel.songsList
            .bind(to: tableView.rx
                .items(cellIdentifier: ArtistTableCell.identifier,
                       cellType: ArtistTableCell.self)) { _, model, cell in
                cell.setData(for: model)
            }.disposed(by: disposeBag)

//        viewModel.subscribe(onError: { [unowned self] in
//            self.show(error: $0.localizedDescription)
//        }).disposed(by: disposeBag)

        tableView.rx.modelSelected(Song.self)
            .asDriver()
            .drive(onNext: { [unowned self] in
                // self.viewModel.playSong.accept($0)
                self.play($0)
            }).disposed(by: disposeBag)
    }

    func play(_ song: Song) {
        PlayerView.shared.play(song: song)
    }
}
