//
//  ArtistsListController.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//
import RxCocoa
import RxSwift
import UIKit

final class ArtistsListController: UIViewController {
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
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
        viewModel.loadData()
    }
}

private extension ArtistsListController {
    func setupTableView() {
        tableView.tableFooterView = ActivityIndicatorView()
        tableView.register(ArtistTableCell.self)
        tableView.showsVerticalScrollIndicator = true
        navigationController?.hidesBarsOnSwipe = false
    }

    func bindToViewModel() {
        viewModel.observer.dataSource
            .bind(to: tableView.rx
                .items(cellIdentifier: ArtistTableCell.identifier,
                       cellType: ArtistTableCell.self)) { _, model, cell in
                cell.setData(for: model)
            }.disposed(by: disposeBag)
        viewModel.observer.error
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [unowned self] in self.show(error: $0) })
            .disposed(by: disposeBag)

        tableView.rx.prefetchRows
            .bind(onNext: { [unowned self] in self.viewModel.observer.loadMoreCells.accept($0) })
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(Artist.self)
            .asDriver()
            .drive(onNext: { [unowned self] in
                let songs = self.viewModel.songsOf(user: $0)
                let songsController = SongsListController(with: SongsViewModel(songs: songs))
                self.navigationController?.pushViewController(songsController, animated: true)
            }).disposed(by: disposeBag)

        viewModel.observer.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [unowned self] in self.tableView.isLoading($0) })
            .disposed(by: disposeBag)
    }
}

extension String {
    static var discover: String { "Mimi".localizedCapitalized }
}
