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
final class ArtistsListController: UITableViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: ArtistsViewModelType
    var artists: [Artist] = []
    init(with viewModel: ArtistsViewModelType = ArtistsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = .discover
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
        tableView.rowHeight = 60
        tableView.accessibilityIdentifier = "ArtistsTable"
        tableView.tableFooterView = ActivityIndicatorView()
        tableView.register(ArtistTableCell.self)
        tableView.showsVerticalScrollIndicator = true
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func bindToViewModel() {
        viewModel.observer.artistsList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [unowned self] in
                self.artists.append(contentsOf: $0)
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.observer.error
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [unowned self] in self.show(error: $0) })
            .disposed(by: disposeBag)

        tableView.rx.prefetchRows
            .bind(onNext: { [unowned self] in self.viewModel.observer.loadMoreCells.accept($0) })
            .disposed(by: disposeBag)

        viewModel.observer.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [unowned self] in self.tableView.isLoading($0) })
            .disposed(by: disposeBag)
    }
}

extension ArtistsListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: ArtistTableCell.self, for: indexPath)
        cell.setData(for: artists[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let songs = viewModel.songsOf(user: artists[indexPath.row])
        let songsController = SongsListController(with: SongsViewModel(with: artists[indexPath.row], and: songs))
        navigationController?.pushViewController(songsController, animated: true)
    }
}

extension String {
    static var discover: String { "Popular Artists".localizedCapitalized }
}
