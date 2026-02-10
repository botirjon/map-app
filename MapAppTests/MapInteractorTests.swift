//
//  MapInteractorTests.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//

import XCTest
@testable import MapApp

final class MapInteractorTests: XCTestCase {
    
    func test_init() {
        let _ = makeSUT()
    }
    
    // when presenter calls loadCoordinates, it should properly invoke loader
    func test_loadCoordinatesOnce_invokesLoadOnce() {
        let (sut, loader, _) = makeSUT()
        
        sut.loadCoordinates()
        
        // then
        XCTAssertEqual(loader.completions.count, 1)
    }
    
    func test_loadCoordinatesTwice_invokesLoadTwice() {
        let (sut, loader, _) = makeSUT()
        
        sut.loadCoordinates()
        sut.loadCoordinates()
        
        XCTAssertEqual(loader.completions.count, 2)
    }
    
    func test_loadCoordinates_tellsPresenterOnLoadingStarted() {
        let (sut, _, presenter) = makeSUT()
        
        sut.loadCoordinates()
        // Important, we are not finishing yet
        
        XCTAssertEqual(presenter.messages, [.beganLoading])
    }
    
    func test_loadCoordinates_tellsPresenterOnFailure() {
        
        let (sut, loader, presenter) = makeSUT()
        
        let expectedError = makeNSError()
        
        sut.loadCoordinates()
        loader.finish(with: makeNSError())
        
        XCTAssertEqual(presenter.messages, [.beganLoading, .failedLoading, .finishedLoading])
        XCTAssertEqual(presenter.results.count, 1)
        switch presenter.results[0] {
        case .failure(let capturedResult as NSError):
            XCTAssertEqual(capturedResult, expectedError)
        default:
            XCTFail("Expected failure, but got \(presenter.results[0]) instead")
        }
    }
    
    func test_loadCoordinates_tellsPresenterOnSucceess() {
        let (sut, loader, presenter) = makeSUT()
        
        let expectedCoordinates = [makeCoordinate(), makeCoordinate()]
        
        sut.loadCoordinates()
        loader.finish(with: expectedCoordinates)
        
        XCTAssertEqual(presenter.messages, [.beganLoading, .succeededLoading, .finishedLoading])
        XCTAssertEqual(presenter.results.count, 1)
        switch presenter.results[0] {
        case .success(let capturedCoordinates):
            XCTAssertEqual(capturedCoordinates, expectedCoordinates)
        default:
            XCTFail("Expected success, but got \(presenter.results[0]) instead")
        }
    }
    
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: MapInteractor, loader: CoordinatesLoaderSpy, presenter: MapPresenterSpy) {
        let loader = CoordinatesLoaderSpy()
        let sut = MapInteractor(loader: loader)
        let presenter = MapPresenterSpy()
        sut.presenter = presenter
        
        testMemoryLeaks(loader, file: file, line: line)
        testMemoryLeaks(presenter, file: file, line: line)
        testMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader, presenter)
    }
    
    private final class CoordinatesLoaderSpy: CoordinatesLoader {
        
        var completions = [(CoordinatesLoader.Result) -> Void]()
        
        func load(completion: @escaping (CoordinatesLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func finish(with error: Error, at index: Int = 0) {
            completions[index](.failure(error))
        }
        
        func finish(with coordinates: [CoordinateEntity], at index: Int = 0) {
            completions[index](.success(coordinates))
        }
    }
    
    private final class MapPresenterSpy: MapInteractorToPresenter {
        
        enum Message {
            case beganLoading
            case finishedLoading
            case succeededLoading
            case failedLoading
        }
        
        private(set) var messages: [Message] = []
        private(set) var results: [Result<[CoordinateEntity], Error>] = []
        
        func interactorDidBeginLoading() {
            messages.append(.beganLoading)
        }
        
        func interactorDidFinishLoading() {
            messages.append(.finishedLoading)
        }
        
        func interactorDidSucceedLoading(_ coordinates: [MapApp.CoordinateEntity]) {
            messages.append(.succeededLoading)
            results.append(.success(coordinates))
        }
        
        func interactorDidFailLoading(with error: any Error) {
            messages.append(.failedLoading)
            results.append(.failure(error))
        }
    }
    
    private func makeNSError() -> NSError {
        NSError(domain: "an error", code: 0)
    }
    
    private func makeCoordinate() -> CoordinateEntity {
        return .init(
            id: UUID(),
            latitude: .random(in: 10...100),
            longitude: .random(in: 10...100),
            title: "a location"
        )
    }
}
