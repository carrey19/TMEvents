//
//  DiscoveryRequestFactoryTests.swift
//  TMEventsTests
//
//  Created by Juan Carlos Carrera Reyes on 26/12/23.
//

import XCTest
@testable import TMEvents

final class DiscoveryRequestFactoryTests: XCTestCase {
    private var sut: DiscoveryServiceProtocol!
    private var mockDiscoveryRequestFactory: MockDiscoveryRequestFactory!

    override func setUp() {
        super.setUp()
        mockDiscoveryRequestFactory = MockDiscoveryRequestFactory()
        sut = DiscoveryRequestFactory()
    }

    override func tearDown() {
        mockDiscoveryRequestFactory = nil
        sut = nil
        super.tearDown()
    }

    func test_realOnlineRequest_searchByKeyword_success() {
        // Given
        let keyword = "taylor"

        // When
        sut.searchEventsBy(keyword: keyword) { result in

        // Then
            switch result {
            case .success(let eventsResponse):
                XCTAssertNotNil(eventsResponse?.embedded.events)
            case .failure(let error):
                XCTFail(error.error)
            }
        }
    }

    func test_mockResponseOffline_searchByKeyword_success() {
        // Given
        mockDiscoveryRequestFactory.isSuccess = true
        let keyword = "taylor"

        // When
        mockDiscoveryRequestFactory.searchEventsBy(keyword: keyword) { result in

        // Then
            switch result {
            case .success(let eventsResponse):
                XCTAssertNotNil(eventsResponse?.embedded.events)
            case .failure(let error):
                XCTFail(error.error)
            }
        }
    }

    func test_realOnlineRequest_searchByKeyword_errorRecuestfailed() {
        // Given
        let keyword = "plo"
        let expectedError: ErrorResponse = .errorRecuestfailed(error: "failedRequest")

        // When
        sut.searchEventsBy(keyword: keyword) { result in

        // Then
            switch result {
            case .success(_):
                XCTFail("Request was success")
            case .failure(let error):
                XCTAssertEqual(error, expectedError)
            }
        }
    }

    func test_mockResponseOffline_searchByKeyword_errorRecuestfailed() {
        // Given
        let keyword = "taylor"
        let expectedError: ErrorResponse = .errorRecuestfailed(error: "failedRequest")
        mockDiscoveryRequestFactory.isSuccess = false
        mockDiscoveryRequestFactory.errorResponse = expectedError

        // When
        mockDiscoveryRequestFactory.searchEventsBy(keyword: keyword) { result in

        // Then
            switch result {
            case .success(_):
                XCTFail("Request was success")
            case .failure(let error):
                XCTAssertEqual(error, expectedError)
            }
        }
    }
    
}
