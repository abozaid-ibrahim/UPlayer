//
//  Observer.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import RxCocoa

struct Observer {
    let error = PublishRelay<String>()
    let loadMoreCells = PublishRelay<[IndexPath]>()
    let isLoading = PublishRelay<Bool>()
    let dataSource = BehaviorRelay<[Artist]>(value: [])
}
