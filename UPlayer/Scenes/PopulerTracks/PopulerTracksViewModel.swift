//
//  ArtistsViewModel.swift
//  UPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import DevNetwork
import Foundation
import RxCocoa
import RxSwift

protocol PopulerTracksViewModelType {
    var observer: Observer { get }
    func loadData()
    func songsOf(user: PopulerTrack) -> [Song]
    func user(of trackId: String) -> Artist?
}

final class PopulerTracksViewModel: PopulerTracksViewModelType {
    let observer = Observer()
    private var scheduler: SchedulerType
    private let disposeBag = DisposeBag()
    private let page = Page()
    private let dataLoader: ReactiveClient
    private var allSongsListCache: [Song] = []

    init(with dataLoader: ReactiveClient = HTTPRxClient(),
         scheduler: SchedulerType = SerialDispatchQueueScheduler(qos: .default)) {
        self.dataLoader = dataLoader
        self.scheduler = scheduler
        subscribeForUIInputs()
    }

    func loadData() {
        observer.isLoading.accept(true)
        dataLoader.getData(of: PopulerTracksAPI.populer(page: page))
            .subscribe(on: scheduler)
            .subscribe(onNext: { [unowned self] in
                self.updateUI($0)
            }, onError: { [unowned self] in
                self.observer.error.accept($0.localizedDescription)
            }, onCompleted: { [unowned self] in
                self.observer.isLoading.accept(false)
            }).disposed(by: disposeBag)
    }

    func songsOf(user: PopulerTrack) -> [Song] {
        return allSongsListCache.filter { $0.userID == user.userId }
    }

    func user(of trackId: String) -> Artist? {
        return allSongsListCache
            .filter { $0.userID == trackId }
            .first?.user
    }
}

private extension PopulerTracksViewModel {
    func updateUI(_ response: [Song]) {
        allSongsListCache.append(contentsOf: response)
        page.newPageFetched()
        observer.artistsList.accept(response.compactMap { PopulerTrack(from: $0) })
    }

    func subscribeForUIInputs() {
        observer.loadMoreCells
            .distinctUntilChanged()
            .subscribe(on: scheduler)
            .filter { [unowned self] in $0.contains(where: { $0.row >= self.allSongsListCache.count - 1 }) }
            .filter { [unowned self] _ in self.page.shouldLoadMore }
            .bind(onNext: { [unowned self] _ in self.loadData() })
            .disposed(by: disposeBag)
    }
}
