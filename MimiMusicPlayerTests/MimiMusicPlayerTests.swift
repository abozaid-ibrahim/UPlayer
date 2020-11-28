//
//  MimiMusicPlayerTests.swift
//  MimiMusicPlayerTests
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

@testable import MimiMusicPlayer
import RxSwift
import RxTest
import XCTest

final class ArtistsViewModelTests: XCTestCase {
    private var disposeBag: DisposeBag!
    var testScheduler: TestScheduler!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        testScheduler = TestScheduler(initialClock: 0)
    }

    func testPagination() throws {
        // Given
        let viewModel = ArtistsViewModel(with: APISuccessMocking(), scheduler: testScheduler)
        let uiDataListObserver = testScheduler.createObserver([Artist].self)
        viewModel.observer.artistsList.bind(to: uiDataListObserver).disposed(by: disposeBag)
        // When
        testScheduler.scheduleAt(5, action: { viewModel.loadData() })
        testScheduler.scheduleAt(10, action: { viewModel.observer.loadMoreCells.accept([.row(1)]) })
        testScheduler.scheduleAt(15, action: { viewModel.observer.loadMoreCells.accept([.row(2)]) })
        testScheduler.start()
        // Then
        XCTAssertEqual(uiDataListObserver.events, [.next(0, []),
                                                   .next(6, [Artist.with(id: 10), Artist.with(id: 20)]),
                                                   .next(11, [Artist.with(id: 10), Artist.with(id: 20)]),
                                                   .next(16, [Artist.with(id: 10), Artist.with(id: 20)])])
    }

    func testFilteringArtistSongs() throws {
        // Given
        let viewModel = ArtistsViewModel(with: APISuccessMocking(), scheduler: testScheduler)
        // When
        testScheduler.scheduleAt(1, action: { viewModel.loadData() })
        testScheduler.start()
        // Then
        XCTAssertEqual(viewModel.songsOf(user: Artist.with(id: 10)).count, 1)
        XCTAssertEqual(viewModel.songsOf(user: Artist.with(id: 20)).count, 1)
        XCTAssertEqual(viewModel.songsOf(user: Artist.with(id: 1)).count, 0)

    }

    func testUnexpectedJsonResponse() throws {
        // Given
        let viewModel = ArtistsViewModel(with: APIFailureMocking(), scheduler: testScheduler)
        let uiErrorObserver = testScheduler.createObserver(String.self)
        viewModel.observer.error.bind(to: uiErrorObserver).disposed(by: disposeBag)
        // When
        testScheduler.scheduleAt(0, action: { viewModel.loadData() })
        testScheduler.start()
        // Then
        XCTAssertEqual(uiErrorObserver.events, [.next(1, NetworkError.connectionFailed.localizedDescription)])
    }
}

final class APISuccessMocking: ApiClient {
    func getData(of request: RequestBuilder?) -> Observable<Data> {
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
    func getData(of request: RequestBuilder?) -> Observable<Data> {
        return Observable<Data>.create { observer in
            observer.onError(NetworkError.connectionFailed)
            return Disposables.create()
        }
    }
}

extension Artist {
    static func with(id: Int) -> Artist {
        return Artist(id: "\(id)", username: "Marten", caption: nil, avatarURL: nil)
    }
}

extension IndexPath {
    static func row(_ position: Int) -> IndexPath {
        return IndexPath(row: position, section: 0)
    }
}
