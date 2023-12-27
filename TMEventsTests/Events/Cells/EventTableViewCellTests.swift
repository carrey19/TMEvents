//
//  EventTableViewCellTests.swift
//  TMEventsTests
//
//  Created by Juan Carlos Carrera Reyes on 26/12/23.
//

import XCTest
@testable import TMEvents

final class EventTableViewCellTests: XCTestCase {
    private var sut: EventTableViewCell!
    private var mockDiscoveryRequestFactory: MockDiscoveryRequestFactory!
    private var eventsViewModel: EventsViewModel!

    override func setUp() {
        super.setUp()
        mockDiscoveryRequestFactory = MockDiscoveryRequestFactory()
        sut = EventTableViewCell()
        eventsViewModel = EventsViewModel(discoveryRequestFactory: mockDiscoveryRequestFactory)
    }

    override func tearDown() {
        mockDiscoveryRequestFactory = nil
        sut = nil
        eventsViewModel = nil
        super.tearDown()
    }

    func test_configureCell_completeEvent() {
        // Given
        mockDiscoveryRequestFactory.isSuccess = true
        eventsViewModel.search(keyword: "taylor")
        guard let event = eventsViewModel.events.first else {
            XCTFail("Fail getting events")
            return
        }

        // When
        sut.configure(with: event)

        // Then
        let cityName = event.embedded?.venues?.first?.city?.name
        let stateCode = event.embedded?.venues?.first?.state?.stateCode
        XCTAssertNotNil(sut.testHooks.eventImageView)
        XCTAssertEqual(sut.testHooks.titleLabel.text, event.name)
        XCTAssertEqual(sut.testHooks.dateLabel.text,
                       event.dates?.start?.localDate?.toMonthFormatDate())
        XCTAssertEqual(sut.testHooks.cityLabel.text,
                       "\(cityName ?? ""), \(stateCode ?? "")")
        XCTAssertEqual(sut.testHooks.venueNameLabel.text,
                       event.embedded?.venues?.first?.name)
    }

}
