//
//  EventsViewModelTests.swift
//  TMEventsTests
//
//  Created by Juan Carlos Carrera Reyes on 26/12/23.
//

import XCTest
@testable import TMEvents

final class EventsViewModelTests: XCTestCase {
    private var sut: EventsViewModel!
    private var mockDiscoveryRequestFactory: MockDiscoveryRequestFactory!

    override func setUp() {
        super.setUp()
        mockDiscoveryRequestFactory = MockDiscoveryRequestFactory()
        sut = EventsViewModel(discoveryRequestFactory: mockDiscoveryRequestFactory)
    }

    override func tearDown() {
        mockDiscoveryRequestFactory = nil
        sut = nil

        super.tearDown()
    }

    func test_searchByKeyword_success() {
        // Given
        mockDiscoveryRequestFactory.isSuccess = true

        // When
        sut.search(keyword: "taylor")

        // Then
        XCTAssertEqual(sut.events.count, 20)
        XCTAssertEqual(sut.state, .finishedLoading)
    }

    func test_searchByKeyword_failure_errorRecuestfailed() {
        // Given
        let expectedError: ErrorResponse = .errorRecuestfailed(error: "failedRequest")
        mockDiscoveryRequestFactory.isSuccess = false
        mockDiscoveryRequestFactory.errorResponse = expectedError

        // When
        sut.search(keyword: "taylor")

        // Then
        XCTAssertEqual(sut.events.count, 0)
        XCTAssertEqual(sut.state, .error(expectedError))
    }

    func test_searchByKeyword_failure_errorParsingResponse() {
        // Given
        let expectedError: ErrorResponse = .errorParsingResponse(error: "fail parsing response")
        mockDiscoveryRequestFactory.isSuccess = false
        mockDiscoveryRequestFactory.errorResponse = expectedError

        // When
        sut.search(keyword: "taylor")

        // Then
        XCTAssertEqual(sut.events.count, 0)
        XCTAssertEqual(sut.state, .error(expectedError))
    }
}
