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
protocol Searchable: UIViewController, UISearchResultsUpdating {
    var searchModel: RemoteSearcher { get }
}

extension Searchable {
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.isTranslucent = false
        navigationItem.searchController = searchController
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.isActive else {
            searchModel.searchCanceled()
            return
        }
        searchModel.search.accept(searchController.searchBar.text)
    }
}
