//
//  PopulerTracksController.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//
import RxCocoa
import RxSwift
import UIKit
final class PopulerTracksController: UITableViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: PopulerTracksViewModelType
    private var tracks: [PopulerTrack] = []
    init(with viewModel: PopulerTracksViewModelType = PopulerTracksViewModel()) {
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
        setupSearchBar()
        viewModel.loadData()
    }
}

private extension PopulerTracksController {
    func setupTableView() {
        tableView.rowHeight = 70
        tableView.accessibilityIdentifier = "PopulerTracksTable"
        tableView.tableFooterView = ActivityIndicatorView()
        tableView.register(SongTableCell.self)
        tableView.showsVerticalScrollIndicator = false
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func bindToViewModel() {
        viewModel.observer.artistsList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [unowned self] in
                self.tracks.append(contentsOf: $0)
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        viewModel.searchResults
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [unowned self] in
                self.tracks = $0
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

    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.isTranslucent = false
//        viewModel.isLoading.subscribe { [weak searchController] isLoading in
//            searchController?.searchBar.isLoading = isLoading
//        }
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
}

extension PopulerTracksController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.isActive else {
            viewModel.searchCanceled()
            return
        }
        viewModel.search.accept(searchController.searchBar.text)
    }
}

extension PopulerTracksController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: SongTableCell.self, for: indexPath)
        cell.setData(for: tracks[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let songs = viewModel.songsOf(user: tracks[indexPath.row])
        guard let artist = viewModel.user(of: tracks[indexPath.row].userId) else { return }
        let songsController = SongsListController(with: SongsViewModel(with: artist, and: songs))
        navigationController?.pushViewController(songsController, animated: true)
    }
}

extension String {
    static var discover: String { "Popular Tracks".localizedCapitalized }
}
