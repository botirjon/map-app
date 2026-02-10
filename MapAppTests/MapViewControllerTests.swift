//
//  MapViewControllerTests.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//

import XCTest
@testable import MapApp
import MapKit

final class MapViewControllerTests: XCTestCase {
    
    func test_init() {
        let _ = MapViewController()
    }
    
    func test_viewDidLoad_embedsViews() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.mapView.superview, sut.view)
        XCTAssertEqual(sut.activityIndicator.superview, sut.view)
    }
    
    func test_displayLoading() {
        let sut = makeSUT()
        sut.displayState(.loading)
        XCTAssertFalse(sut.activityIndicator.isHidden)
    }
    
    func test_displayCoordinates_displaysCoordinates() {
        let expectedAnnotations = [makeMKPointAnnotation(), makeMKPointAnnotation()]
        let sut = makeSUT()
        sut.displayState(.ready(coordinates: expectedAnnotations))
        let capturedAnnotations = Set(sut.mapView.annotations as? [MKPointAnnotation] ?? [])
        
        XCTAssertEqual(capturedAnnotations, Set(expectedAnnotations))
    }
    
    func test_displayCoordinates_displaysError() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let expectedErrorMessage = "a message"
        let sut = makeSUT()
        
        window.rootViewController = sut
        window.makeKeyAndVisible()
        
        sut.displayState(.error(makeNSError(message: expectedErrorMessage)))
        
        // Give RunLoop time to process
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01))
        
        let alert = sut.presentedViewController as? UIAlertController
        
        XCTAssertNotNil(alert, "Expected error alert to be presented")
        XCTAssertEqual(alert?.message, expectedErrorMessage)
        
        // Clean up before memory leak check runs
        window.rootViewController = nil
        window.isHidden = true
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> MapViewController {
        let sut = MapViewController()
        sut.loadViewIfNeeded()
        testMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func makeMKPointAnnotation() -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        pin.title = "an annotation"
        return pin
    }
    
    private func makeNSError(message: String = "a message") -> NSError {
        let userInfo: [String: Any] = [
            NSLocalizedDescriptionKey: message
        ]
        return NSError(domain: "MapApp.MapViewControllerTests.Error", code: 0, userInfo: userInfo)
    }
    
    @discardableResult
    private func makeWindow(with rootViewController: UIViewController) -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = rootViewController
        return window
    }
}


private extension MapViewController {
    enum MapViewControllerState {
        case loading
        case ready(coordinates: [MKPointAnnotation])
        case error(Error)
        case none
    }
    
    func displayState(_ state: MapViewControllerState) {
        switch state {
        case .loading:
            displayLoading(true)
            
        case .ready(coordinates: let coordinates):
            displayLoading(false)
            let viewModel = MapViewModel<MKPointAnnotation>(coordinates: coordinates)
            displayCoordinates(viewModel)
        
        case .error(let error):
            displayLoading(false)
            displayError(error.localizedDescription)
        
        case .none:
            displayLoading(false)
        }
    }
}
