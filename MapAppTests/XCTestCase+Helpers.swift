//
//  XCTestCase+Helpers.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//
import XCTest

extension XCTestCase {
    func testMemoryLeaks(_ object: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(object, "Expected the object to be deallocated", file: file, line: line)
        }
    }
}
