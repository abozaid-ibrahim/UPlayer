//
//  ArtistsViewModel.swift
//  UPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

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
    func user(of trackId: String) -> Artist? {
        return allSongsListCache
            .filter { $0.userID == trackId }
            .first?.user
    }

    let observer = Observer()
    private var scheduler: SchedulerType
    private let disposeBag = DisposeBag()
    private let page = Page()
    private let dataLoader: ApiClient
    private var allSongsListCache: [Song] = []

    init(with dataLoader: ApiClient = HTTPClient(),
         scheduler: SchedulerType = SerialDispatchQueueScheduler(qos: .default)) {
        self.dataLoader = dataLoader
        self.scheduler = scheduler
        subscribeForUIInputs()
    }

    func loadData() {
        observer.isLoading.accept(true)
        dataLoader.getData(of: PopulerTracksAPI.populer(page: page))
            .subscribeOn(scheduler)
            .map { try JSONDecoder().decode([Song].self, from: $0) }
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
}

private extension PopulerTracksViewModel {
    func updateUI(_ response: [Song]) {
        allSongsListCache.append(contentsOf: response)
        page.newPageFetched()
        observer.artistsList.accept(response.compactMap { $0.uiUserModel })
    }

    func subscribeForUIInputs() {
        observer.loadMoreCells
            .distinctUntilChanged()
            .subscribeOn(scheduler)
            .filter { [unowned self] in $0.contains(where: { $0.row >= self.allSongsListCache.count - 1 }) }
            .filter { [unowned self] _ in self.page.shouldLoadMore }
            .bind(onNext: { [unowned self] _ in self.loadData() })
            .disposed(by: disposeBag)
    }
}
