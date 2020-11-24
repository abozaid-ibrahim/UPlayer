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
    func loadData()
    var isLoading: PublishRelay<Bool> { get }
    var dataSource: BehaviorRelay<[Artist]> { get }
    var artistSelected: BehaviorRelay<Artist?> { get }
}

final class ArtistsViewModel: ArtistsViewModelType {
    let isLoading = PublishRelay<Bool>()
    let dataSource = BehaviorRelay<[Artist]>(value: [])
    let artistSelected = BehaviorRelay<Artist?>(value: nil)
    private let disposeBag = DisposeBag()
    private let page = Page()
    private let dataLoader: ApiClient
    private let scheduler: SchedulerType
    private(set) var cache: [Artist] = []
    init(with dataLoader: ApiClient = HTTPClient(),
         scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .default)) {
        self.dataLoader = dataLoader
        self.scheduler = scheduler
        subscribeForUIInputs()
    }

    func loadData() {
        isLoading.accept(true)
        dataLoader.getData(of: ArtistAPI.populer(page: page)) {
            switch $0 {
            case let .success(data):
                do {
                    let response: [Artist] = try data.parse()
                    self.dataSource.accept(response)
                } catch {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
            self.page.isFetchingData = false
            self.isLoading.accept(false)
        }
    }
}

private extension ArtistsViewModel {
    func sortAndUpdateUI() {
    }

    func subscribeForUIInputs() {
        artistSelected.bind(onNext: { [unowned self] _ in })
            .disposed(by: disposeBag)
    }
}
