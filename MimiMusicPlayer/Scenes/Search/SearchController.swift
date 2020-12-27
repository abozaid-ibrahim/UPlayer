//
//  SearchController.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 27.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol Searchable {
    var searchModel: RemoteSearcher { get }
    var disposeBag: DisposeBag { get }
}

extension Searchable where Self: UIViewController {
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.rx.willDismiss
            .subscribe(onNext: { [weak self] in
                self?.searchModel.searchCanceled()
            }).disposed(by: disposeBag)
        searchController.searchBar.rx.text
            .bind { [unowned self] in self.searchModel.search.accept($0) }
            .disposed(by: disposeBag)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.isTranslucent = false
        navigationItem.searchController = searchController
        searchModel.subscribeForSearch(dataLoader: HTTPClient())
    }
}
