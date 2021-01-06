//
import DevExtensions
//  PopulerTracksController.swift
//  UPlayer
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
    required init?(coder _: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindToViewModel()
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

extension PopulerTracksController {
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return tracks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: SongTableCell.self, for: indexPath)
        cell.setData(for: tracks[indexPath.row])
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let songs = viewModel.songsOf(user: tracks[indexPath.row])
        guard let artist = viewModel.user(of: tracks[indexPath.row].userId) else { return }
        AppNavigator.shared.push(.songsList(for: artist, and: songs))
    }
}

extension String {
    static var discover: String { "Popular Tracks".localizedCapitalized }
}
