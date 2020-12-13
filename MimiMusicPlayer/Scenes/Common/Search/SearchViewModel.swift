//
//  SearchViewModel.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 12.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol SearchViewModelType {
    var disposeBag: DisposeBag { get }
    var searchResults: BehaviorRelay<[PopulerTrack]> { get }
    var search: BehaviorRelay<String?> { get }
    func searchCanceled()
}

extension SearchViewModelType {
    func subscribeForSearch(dataLoader: ApiClient) {
        search.distinctUntilChanged()
            .filter { !($0 ?? "").isEmpty }
            .debounce(.milliseconds(350), scheduler: SharingScheduler.make())
            .subscribe(onNext: {
                dataLoader.getData(of: PopulerTracksAPI.search(for: $0 ?? ""))
                    .debug()
                    .map { try JSONDecoder().decode([Song].self, from: $0) }
                    .debug()
                    .subscribe(onNext: {
                        let response = $0.compactMap { $0.uiUserModel }
                        self.searchResults.accept(response)
                    }, onError: {
                        print($0)
                        self.searchResults.accept([])
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
}

final class RemoteSearcher: SearchViewModelType {
    let disposeBag: DisposeBag = DisposeBag()
    let searchResults: BehaviorRelay<[PopulerTrack]> = .init(value: [])
    let search: BehaviorRelay<String?> = .init(value: nil)

    func searchCanceled() {
    }

    func subscribeForSearch(dataLoader: ApiClient) {
       
    }
}
