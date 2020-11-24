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
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = ActivityIndicatorView()
        tableView.register(ArtistTableCell.self)
        tableView.showsVerticalScrollIndicator = true
        navigationController?.hidesBarsOnSwipe = false
    }

    func bindToViewModel() {
        let data = viewModel.dataSource.share()

        data.bind(to: tableView.rx.items(cellIdentifier: ArtistTableCell.identifier,
                                         cellType: ArtistTableCell.self)) {  _, model, cell in
            cell.setData(for: model)
        }.disposed(by: disposeBag)

        data.subscribe(onError: { [unowned self] in
            self.show(error: $0.localizedDescription)
        })
            .disposed(by: disposeBag)

        viewModel.isLoading.asDriver(onErrorJustReturn: false)
            .asDriver()
            .drive(onNext: { [unowned self] in self.tableView.isLoading($0) })
            .disposed(by: disposeBag)
    }
}

extension String {
    static var discover: String { "Mimi".localizedCapitalized }
}
