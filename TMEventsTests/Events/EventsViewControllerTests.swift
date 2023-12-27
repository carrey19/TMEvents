//
//  EventsViewControllerTests.swift
//  TMEventsTests
//
//  Created by Juan Carlos Carrera Reyes on 26/12/23.
//

import XCTest
@testable import TMEvents

final class EventsViewControllerTests: XCTestCase {
    private var sut: EventsViewController!
    private var eventsViewModel: EventsViewModel!
    private var mockDiscoveryRequestFactory: MockDiscoveryRequestFactory!

    override func setUp() {
        super.setUp()
        mockDiscoveryRequestFactory = MockDiscoveryRequestFactory()
        eventsViewModel = EventsViewModel(discoveryRequestFactory: mockDiscoveryRequestFactory)
        sut = EventsViewController(viewModel: eventsViewModel)
    }

    override func tearDown() {
        mockDiscoveryRequestFactory = nil
        eventsViewModel = nil
        sut = nil
        super.tearDown()
    }

    func test_initState() {
        // When
        sut.viewDidLoad()

        // Then
        XCTAssertEqual(sut.testHooks.viewModel?.events.count, 0)
        XCTAssertEqual(sut.testHooks.viewModel?.state, .initState)
        XCTAssertNotNil(sut.testHooks.monitor)
    }

    func test_searchByKeyword_success() {
        // Given
        let searchText = "taylor"
        mockDiscoveryRequestFactory.isSuccess = true

        // When
        sut.testHooks.viewModel?.search(keyword: searchText)
        // Then
        XCTAssertEqual(sut.testHooks.viewModel?.events.count, 20)
        XCTAssertEqual(sut.testHooks.viewModel?.state, .finishedLoading)
        XCTAssertFalse(sut.testHooks.activityView.isAnimating)
        XCTAssertTrue(sut.testHooks.tableView.isUserInteractionEnabled)
    }

    func test_searchByKeyword_failure_errorRecuestfailed() {
        // Given
        let searchText = "taylor"
        let expectedError: ErrorResponse = .errorRecuestfailed(error: "failedRequest")
        mockDiscoveryRequestFactory.isSuccess = false
        mockDiscoveryRequestFactory.errorResponse = expectedError

        // When
        sut.testHooks.viewModel?.search(keyword: searchText)

        // Then
        XCTAssertEqual(sut.testHooks.viewModel?.events.count, 0)
        XCTAssertEqual(sut.testHooks.viewModel?.state, .error(expectedError))
        XCTAssertFalse(sut.testHooks.activityView.isAnimating)
        XCTAssertTrue(sut.testHooks.tableView.isUserInteractionEnabled)
    }
}
