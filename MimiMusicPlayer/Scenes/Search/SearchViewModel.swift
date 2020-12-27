//
//  SearchViewModel.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 27.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol SearchViewModelType {
    var disposeBag: DisposeBag { get }
    var searchResults: BehaviorRelay<[Song]> { get }
    var search: BehaviorRelay<String?> { get }
    func searchCanceled()
}

final class RemoteSearcher: SearchViewModelType {
    let disposeBag: DisposeBag = DisposeBag()
    let searchResults: BehaviorRelay<[Song]> = .init(value: [])
    let search: BehaviorRelay<String?> = .init(value: nil)

    func searchCanceled() {
        searchResults.accept([])
    }

    func subscribeForSearch(dataLoader: ApiClient = HTTPClient()) {
        search.distinctUntilChanged()
            .filter { !($0 ?? "").isEmpty }
            .debounce(.milliseconds(350), scheduler: SharingScheduler.make())
            .subscribe(onNext: {
                dataLoader.getData(of: SearchAPI.search(for: $0 ?? ""))
                    .debug()
                    .map { try JSONDecoder().decode([Song].self, from: $0) }
                    .debug()
                    .subscribe(onNext: { [weak self] in
                        self?.searchResults.accept($0)
                    }, onError: { [weak self] _ in
                        self?.searchResults.accept([])
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
}
