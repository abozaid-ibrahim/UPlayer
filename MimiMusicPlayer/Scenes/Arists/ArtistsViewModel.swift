//
//  ArtistsViewModel.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ArtistsViewModelType {
    var observer: Observer { get }
    func loadData()
    func songsOf(user: Artist) -> [Song]
}

final class ArtistsViewModel: ArtistsViewModelType {
    let observer = Observer()
    private let disposeBag = DisposeBag()
    private let page = Page()
    private let dataLoader: ApiClient
    private let scheduler: SchedulerType
    private(set) var allSongsListCache: [Song] = []
    init(with dataLoader: ApiClient = HTTPClient(),
         scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .default)) {
        self.dataLoader = dataLoader
        self.scheduler = scheduler
        subscribeForUIInputs()
    }

    func loadData() {
        guard !page.isFetchingData else {
            return
        }
        page.isFetchingData = true
        observer.isLoading.accept(true)
        dataLoader.getData(of: ArtistAPI.populer(page: page)) { [unowned self] in
            switch $0 {
            case let .success(data):
                self.parse(data)
            case let .failure(error):
                self.observer.error.accept(error.localizedDescription)
            }
            self.observer.isLoading.accept(false)
            self.page.isFetchingData = false
        }
    }

    func songsOf(user: Artist) -> [Song] {
        return allSongsListCache.filter { $0.userID == user.id }
    }
}

private extension ArtistsViewModel {
    func parse(_ data: Data) {
        do {
            let response: [Song] = try data.parse()
            allSongsListCache.append(contentsOf: response)
            observer.dataSource.accept(allSongsListCache.sortSongsByArtist())
            page.newPageFetched()
        } catch {
            print(error)
            observer.error.accept(NetworkError.failedToParseData.localizedDescription)
        }
    }

    func subscribeForUIInputs() {
        observer.loadMoreCells
            .distinctUntilChanged()
            .bind(onNext: { [unowned self] in
                self.loadMoreCells(prefetchRowsAt: $0)
            })
            .disposed(by: disposeBag)
    }

    func loadMoreCells(prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { $0.row + 1 >= observer.dataSource.value.count }) {
            loadData()
        }
    }
}

extension Array where Element == Song {
    func sortSongsByArtist() -> [Artist] {
        var users: [String: Artist] = [:]
        for song in self {
            guard var user = users[song.userID] ?? song.user else { continue }
            user.tracksCount += 1
            users[song.userID] = user
        }
        return users.values.map { $0 } // .sorted { $0.tracksCount > $1.tracksCount }
    }
}
