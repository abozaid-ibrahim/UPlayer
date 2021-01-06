//
//  UPlayerTests.swift
//  UPlayerTests
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import RxSwift
import RxTest
@testable import UPlayer
import XCTest

final class PopulerTracksViewModelTests: XCTestCase {
    private var disposeBag: DisposeBag!
    var testScheduler: TestScheduler!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        testScheduler = TestScheduler(initialClock: 0)
    }

    func testPagination() throws {
        // Given
        let viewModel = PopulerTracksViewModel(with: APISuccessMocking(), scheduler: testScheduler)
        let uiDataListObserver = testScheduler.createObserver([PopulerTrack].self)
        viewModel.observer.artistsList.bind(to: uiDataListObserver).disposed(by: disposeBag)
        // When
        testScheduler.scheduleAt(5, action: { viewModel.loadData() })
        testScheduler.scheduleAt(10, action: { viewModel.observer.loadMoreCells.accept([.row(1)]) })
        testScheduler.scheduleAt(15, action: { viewModel.observer.loadMoreCells.accept([.row(4)]) })
        testScheduler.start()
        // Then
        XCTAssertEqual(uiDataListObserver.events, [.next(0, []),
                                                   .next(6, [PopulerTrack.with(id: 1), PopulerTrack.with(id: 2)]),
                                                   .next(11, [PopulerTrack.with(id: 1), PopulerTrack.with(id: 2)]),
                                                   .next(16, [PopulerTrack.with(id: 1), PopulerTrack.with(id: 2)])])
    }

    func testFilteringArtistSongs() throws {
        // Given
        let viewModel = PopulerTracksViewModel(with: APISuccessMocking(), scheduler: testScheduler)
        // When
        testScheduler.scheduleAt(1, action: { viewModel.loadData() })
        testScheduler.start()
        // Then
        XCTAssertEqual(viewModel.songsOf(user: PopulerTrack.with(id: 1, uid: 10)).count, 1)
        XCTAssertEqual(viewModel.songsOf(user: PopulerTrack.with(id: 2, uid: 20)).count, 1)
        XCTAssertEqual(viewModel.songsOf(user: PopulerTrack.with(id: 10, uid: 1)).count, 0)
    }

    func testUnexpectedJsonResponse() throws {
        // Given
        let viewModel = PopulerTracksViewModel(with: APIFailureMocking(), scheduler: testScheduler)
        let uiErrorObserver = testScheduler.createObserver(String.self)
        viewModel.observer.error.bind(to: uiErrorObserver).disposed(by: disposeBag)
        // When
        testScheduler.scheduleAt(0, action: { viewModel.loadData() })
        testScheduler.start()
        // Then
        XCTAssertEqual(uiErrorObserver.events, [.next(1, NetworkError.failedToParseData.localizedDescription)])
    }
}

final class APISuccessMocking: ApiClient {
    func getData(of _: RequestBuilder?) -> Observable<Data> {
        let response = """
        [{"id":"1","user_id":"10","duration":"3782","title":"Hello", "stream_url":"https://hear.at",
        "user":{"id":"10","username":"Adele"}},
        {"id":"2","user_id":"20","duration":"3782","title":"Whenever", "stream_url":"https://hear.at",
        "user":{"id":"20","username":"Shakira"}}]
        """
        let data = response.data(using: .utf8)!
        return Observable.of(data)
    }
}

final class APIFailureMocking: ApiClient {
    func getData(of _: RequestBuilder?) -> Observable<Data> {
        return Observable<Data>.create
            { observer in
                observer.onError(NetworkError.failedToParseData)
                return Disposables.create()
            }
    }
}

extension Artist {
    static func with(id: Int) -> Artist {
        return Artist(id: "\(id)", username: "Marten", caption: nil, avatarURL: nil)
    }
}

extension PopulerTrack {
    static func with(id: Int, uid: Int = 0) -> PopulerTrack {
        return PopulerTrack(id: "\(id)", userId: String(uid), title: nil, duration: "0", username: nil, avatar: nil)
    }
}

extension IndexPath {
    static func row(_ position: Int) -> IndexPath {
        return IndexPath(row: position, section: 0)
    }
}
